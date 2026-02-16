# RELEASE WEB CHECKLIST (FincaApp Frontend)

Checklist operativo para despliegues web con Flutter + Nginx + Cloudflare.

## 1) Build limpio

- [ ] Ejecutar:
  - `flutter clean`
  - `flutter pub get`
  - `flutter build web --release`
- [ ] Confirmar que el build terminó sin errores.

## 2) Imagen y despliegue

- [ ] Construir y desplegar imagen nueva:
  - `docker-compose up -d --build`
  - o pipeline CI/CD equivalente.
- [ ] Verificar que el contenedor nuevo está arriba y saludable.

## 3) Validar headers de caché en origen (Nginx)

- [ ] Archivos críticos con no-cache fuerte (`no-store, no-cache, must-revalidate`):
  - `/index.html`
  - `/main.dart.js`
  - `/flutter_bootstrap.js`
  - `/env-config.js`
- [ ] Archivos estáticos con caché controlada:
  - imágenes, fuentes, css/js no críticos con `max-age` apropiado.
- [ ] Confirmar que no exista `Clear-Site-Data: "cache"` en respuestas normales.

## 4) Cloudflare

- [ ] Confirmar `Origin Cache Control` activo.
- [ ] Purge post-deploy de rutas críticas:
  - `/index.html`
  - `/main.dart.js`
  - `/flutter_bootstrap.js`
  - `/env-config.js`
- [ ] Verificar que Cloudflare no esté sirviendo build anterior.

## 5) Smoke test funcional

- [ ] Login correcto.
- [ ] Navegación principal correcta:
  - Home
  - Cattle
  - Purchases
  - Sales
- [ ] Logout correcto.
- [ ] Recarga directa por URL interna (deep link) funciona.

## 6) Validación de performance (DevTools)

- [ ] Medir primera carga (cold).
- [ ] Medir segunda carga (warm).
- [ ] Confirmar mejora entre cold vs warm.
- [ ] Confirmar que no se está limpiando caché en cada navegación.

## 7) Verificación de versión desplegada

- [ ] Confirmar `version.json`/timestamp/indicador visible del release actual.
- [ ] Confirmar commit SHA o tag correspondiente al despliegue.

## 8) Rollback preparado

- [ ] Tener imagen/tag anterior identificado.
- [ ] Tener comando/procedimiento de rollback validado.

## 9) Registro del release

- [ ] Guardar evidencia:
  - fecha y hora de despliegue
  - commit SHA
  - imagen desplegada
  - rutas purgadas en Cloudflare
  - tiempos cold/warm
- [ ] Compartir estado final con el equipo.

