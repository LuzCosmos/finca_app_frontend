#!/bin/sh
set -e

: "${API_BASE_URL:?API_BASE_URL must be set via docker-compose environment}"

if [ "${API_BASE_URL}" = "null" ]; then
  echo "Error: API_BASE_URL environment variable is set to the literal string 'null'. Please provide a valid URL."
  exit 1
fi

# Default backend URL if not set
export BACKEND_URL="${BACKEND_URL:-http://finca_app_backend:3000}"

WEB_ROOT="/usr/share/nginx/html"
BOOT="${WEB_ROOT}/flutter_bootstrap.js"

echo "[entrypoint] Starting frontend runtime init..."

###############################################################################
# 1) Deploy de limpieza: impedir que Flutter registre service worker
#    (Elimina el bloque serviceWorkerSettings:{...} aunque cierre en la misma línea)
###############################################################################
if [ -f "$BOOT" ]; then
  echo "[entrypoint] Patching flutter_bootstrap.js to remove serviceWorkerSettings block (balanced braces)..."

  awk '
    BEGIN { skipping=0; depth=0 }

    skipping==0 {
      if ($0 ~ /serviceWorkerSettings:[[:space:]]*\{/) {
        skipping=1

        # contamos llaves en esta línea
        nOpen = gsub(/\{/, "{")
        nClose = gsub(/\}/, "}")
        depth += (nOpen - nClose)

        # quitamos todo desde serviceWorkerSettings:{ hasta el final de la línea
        sub(/,?[[:space:]]*serviceWorkerSettings:[[:space:]]*\{.*/, "", $0)

        # si después de remover queda algo útil, imprímelo
        if (length($0) > 0) print $0

        # si el bloque se cerró en la misma línea
        if (depth <= 0) { skipping=0; depth=0 }
        next
      }

      print
      next
    }

    skipping==1 {
      # seguimos contando llaves hasta que depth vuelva a 0
      nOpen = gsub(/\{/, "{")
      nClose = gsub(/\}/, "}")
      depth += (nOpen - nClose)

      if (depth <= 0) { skipping=0; depth=0 }
      next
    }
  ' "$BOOT" > "${BOOT}.tmp" && mv "${BOOT}.tmp" "$BOOT"
fi

###############################################################################
# 2) Generar env-config.js (runtime env para Flutter Web)
###############################################################################
cat > "${WEB_ROOT}/env-config.js" <<EOF
window.ENV = {
  API_BASE_URL: "${API_BASE_URL}"
};
EOF

echo "[entrypoint] Generated env-config.js:"
cat "${WEB_ROOT}/env-config.js"

###############################################################################
# 3) Seguridad: eliminar .env expuesto en assets si existe
###############################################################################
if [ -f "${WEB_ROOT}/assets/.env" ]; then
  rm -f "${WEB_ROOT}/assets/.env"
  echo "[entrypoint] Secured: Removed .env file from assets"
fi

###############################################################################
# 4) Inyectar BACKEND_URL en nginx.conf (proxy /api)
###############################################################################
sed -i "s|{{BACKEND_URL}}|${BACKEND_URL}|g" /etc/nginx/nginx.conf
echo "[entrypoint] Injected BACKEND_URL into nginx.conf: ${BACKEND_URL}"

###############################################################################
# 5) Strip sourceMappingURL para evitar warnings
###############################################################################
echo "[entrypoint] Stripping source maps from JS files..."
if [ -f "${WEB_ROOT}/flutter_bootstrap.js" ]; then
  sed -i '/sourceMappingURL/d' "${WEB_ROOT}/flutter_bootstrap.js"
fi
if [ -f "${WEB_ROOT}/main.dart.js" ]; then
  sed -i '/sourceMappingURL/d' "${WEB_ROOT}/main.dart.js"
fi
find "${WEB_ROOT}" -name "*.js" -type f -exec sed -i '/sourceMappingURL=/d' {} \;

###############################################################################
# 6) Service worker de limpieza (solo deploy 1)
###############################################################################
cat > "${WEB_ROOT}/flutter_service_worker.js" <<'EOF'
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    // borra todos los caches
    const keys = await caches.keys();
    await Promise.all(keys.map((k) => caches.delete(k)));

    // toma control inmediato
    await self.clients.claim();

    // fuerza recarga de pestañas abiertas
    const clientsArr = await self.clients.matchAll({
      type: 'window',
      includeUncontrolled: true
    });
    for (const client of clientsArr) {
      client.navigate(client.url);
    }

    // desregistra el SW
    await self.registration.unregister();
  })());
});
EOF

FLUTTER_JS="${WEB_ROOT}/flutter.js"
if [ -f "$FLUTTER_JS" ]; then
  echo "[entrypoint] Patching flutter.js to disable serviceWorkerSettings..."
  awk '
    BEGIN { skipping=0; depth=0 }

    skipping==0 {
      if ($0 ~ /serviceWorkerSettings:[[:space:]]*\{/) {
        skipping=1
        nOpen = gsub(/\{/, "{")
        nClose = gsub(/\}/, "}")
        depth += (nOpen - nClose)

        sub(/,?[[:space:]]*serviceWorkerSettings:[[:space:]]*\{.*/, "", $0)
        if (length($0) > 0) print $0

        if (depth <= 0) { skipping=0; depth=0 }
        next
      }
      print
      next
    }

    skipping==1 {
      nOpen = gsub(/\{/, "{")
      nClose = gsub(/\}/, "}")
      depth += (nOpen - nClose)
      if (depth <= 0) { skipping=0; depth=0 }
      next
    }
  ' "$FLUTTER_JS" > "${FLUTTER_JS}.tmp" && mv "${FLUTTER_JS}.tmp" "$FLUTTER_JS"
fi



###############################################################################
# 7) Verificación en logs (para no adivinar)
###############################################################################
echo "[entrypoint] Bootstrap SW settings (config block should be gone):"
grep -n 'serviceWorkerSettings:[[:space:]]*{' "${WEB_ROOT}/flutter_bootstrap.js" | head -n 5 || true

echo "[entrypoint] Runtime init complete. Starting nginx..."


cat > /usr/share/nginx/html/kill-sw.html <<'EOF'
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Reset</title></head>
<body>
<script>
(async () => {
  try {
    if ('serviceWorker' in navigator) {
      const regs = await navigator.serviceWorker.getRegistrations();
      await Promise.all(regs.map(r => r.unregister()));
    }
    if ('caches' in window) {
      const keys = await caches.keys();
      await Promise.all(keys.map(k => caches.delete(k)));
    }
  } finally {
    // vuelve a la app
    location.replace('/?reset=' + Date.now());
  }
})();
</script>
Resetting…
</body>
</html>
EOF

exec "$@"
