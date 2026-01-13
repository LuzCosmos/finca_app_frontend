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
#    (Esto evita el error addAll del SW normal y evita volver a cachear)
###############################################################################
if [ -f "$BOOT" ]; then
  echo "[entrypoint] Patching flutter_bootstrap.js to remove serviceWorkerSettings block..."

  # AWK robusto: elimina desde la línea que contiene 'serviceWorkerSettings: {' hasta
  # la primera línea que contenga un '}' (en cualquier posición) mientras estamos en skip.
  # Esto funciona aunque esté minificado o con saltos de línea raros.
  awk '
    BEGIN { skip=0 }
    /serviceWorkerSettings:[[:space:]]*\{/ { skip=1; next }
    skip==1 {
      if ($0 ~ /\}/) { skip=0 }
      next
    }
    { print }
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

###############################################################################
# 7) Verificación en logs (para no adivinar)
###############################################################################
echo "[entrypoint] Bootstrap SW settings (should be empty):"
grep -n 'serviceWorkerSettings:' "${WEB_ROOT}/flutter_bootstrap.js" | head -n 5 || true

echo "[entrypoint] Runtime init complete. Starting nginx..."
exec "$@"
