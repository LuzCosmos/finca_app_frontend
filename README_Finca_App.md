# Finca App - README Técnico

Este documento resume el estado actual del proyecto Flutter para la app de finca, incluyendo estructura de archivos, funcionalidades implementadas, y consideraciones técnicas para mantenimiento y evolución.

---

## ✨ Propósito General
Aplicación de gestión para finca con funcionalidades de compra, recepción, evento masivo y venta. Compatible con web y dispositivos móviles.

---

## 🗂 Estructura del Proyecto (Resumen)

```
lib/
├── main.dart                      # Punto de entrada con GoRouter
├── router.dart                    # Configuración de rutas con GoRouter
├── core/
│   └── services/
│       ├── auth_service.dart      # Autenticación JWT
│       └── session_service.dart   # Manejo de sesión activa
├── modules/
│   ├── shared/widgets/
│   │   ├── auth/login_form.dart   # Formulario de login
│   │   └── home_option_card.dart  # Widget de opción en pantalla de inicio
│   └── pages/
│       ├── login_page.dart        # Pantalla de login
│       ├── home_page.dart         # Pantalla principal
│       ├── loading_page.dart      # Pantalla intermedia de carga/sesión
│       └── cattle_purchase/
│           ├── views/
│           │   └── purchase_form_page.dart  # Página principal de compra de ganado
│           └── widgets/
│               └── provider_input.dart      # Formulario de proveedor por NIT
├── platform/
│   ├── detectors/platform_detector.dart   # Lógica de detección de plataforma
│   └── services/platform_sevice.dart      # Servicio de plataforma
├── l10n/
    ├── app_es.arb                # Localización en español
    └── app_en.arb                # Localización en inglés
```

---

## 🚀 Funcionalidades Implementadas

| Módulo                        | Estado | Descripción |
|-------------------------------|--------|-------------|
| Login JWT                    | ✅     | Autenticación con username, password y empresa |
| Home adaptado por plataforma | ✅     | Muestra opciones diferentes según web/mobile |
| GoRouter                     | ✅     | Navegación declarativa con rutas protegidas |
| Internacionalización        | ✅     | `l10n` funcionando con arb files en `es` e `en` |
| Detección de plataforma      | ✅     | Mediante servicios y `PlatformDetector` |
| Modularización de widgets    | ✅     | `HomeOptionCard` extraído de `home_page.dart` |
| Gestión de sesión persistente| ✅     | Con `SharedPreferences` y validación en `/loading` |
| Navegación a módulo "Compra" | ✅     | Ruta declarada (`/purchase`) desde `HomePage` |

---

## 🐄 Módulo Compra de Ganado (en desarrollo)

### Estado actual:
- `purchase_form_page.dart`: estructura de la pantalla principal ya implementada.
- `provider_input.dart`: widget funcional con búsqueda simulada por NIT y carga de nombre.
- Navegación desde `HomePage` a `/purchase` lista y funcionando.

### Pendiente por implementar:
- Conexión real a backend NestJS para:
  - Buscar proveedor por NIT (`GET /providers/:nit`)
  - Crear proveedor nuevo (`POST /providers`)
  - Crear compra con detalle (`POST /purchases`)
- Crear:
  - `LotDetailForm` (formulario por lote)
  - `PurchaseSummary` con totales y promedios
  - Validaciones del formulario
  - Envío completo del formulario al backend

---

## 💡 Sugerencias de Mejora / Pendientes

1. **Logout funcional:** limpiar sesión y redirigir a `/login`.
2. **Validación de sesión expirada:** decodificar JWT y verificar expiración.
3. **Redirecciones más seguras:** manejar errores silenciosos en `LoadingPage`.
4. **Agregar pruebas unitarias:** para `AuthService`, `SessionService`, y `LoginForm`.
5. **Desarrollar módulos funcionales de "Compra"**: gestión de lotes y reses sin lote.
6. **Integrar `PurchaseService`** con endpoints reales de NestJS.

---

## 🌐 Plataforma
- App funciona en Web y Mobile (iOS/Android)
- Uso de `Platform.isX` y `kIsWeb` para condiciones.

---

## 🌐 Localización (i18n)
- Archivos `.arb` bajo `/l10n`
- Claves traducidas para login, botones, formulario de compra, y navegación

### Ejemplos de claves ya incluidas:
- `"provider"`: "Proveedor"
- `"nit"`: "NIT"
- `"purchaseDate"`: "Fecha de compra"
- `"addLot"`: "Agregar lote"
- `"createPurchase"`: "Crear compra"
- `"providerFound"`: "Proveedor encontrado y cargado."
- `"providerWillBeCreated"`: "Se creará un nuevo proveedor con este NIT."

---

## ✅ Navegación declarativa con `go_router`
- `router.dart` contiene lógica de rutas y pantalla `/loading`
- Soporta navegación:
  - `/login`
  - `/home`
  - `/purchase`
- Redirección automática según sesión activa con `SessionService`

---

## ⚡ Tips para reanudar trabajo

1. Verifica que `flutter pub get` se ejecute sin errores.
2. Ejecuta `flutter run -d chrome` o `flutter run -d ios` para iniciar.
3. Para limpiar sesión manualmente:

```dart
await SessionService.cleanSession();
context.go('/login');
```

4. Si ocurre bloqueo en `flutter run`, revisar:
   - Que el `redirect` en `router.dart` **no sea async**
   - Usar `WidgetsFlutterBinding.ensureInitialized();` en `main()`

---

## 📃 Historial de Archivos Revisados
- `main.dart`
- `router.dart`
- `login_form.dart`
- `auth_service.dart`
- `home_page.dart`
- `session_service.dart`
- `purchase_form_page.dart`
- `provider_input.dart`
- `loading_page.dart`
- `home_option_card.dart`

---

> ✨ Este README fue generado automáticamente para ayudarte a retomar rápidamente el desarrollo y mantener la organización del código. Última actualización: **julio 2025**.