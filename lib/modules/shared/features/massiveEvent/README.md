# Módulo Flutter — Evento masivo (`massiveEvent`)

Feature compartido (web y móvil): creación y gestión de **eventos masivos** y **simple events**, listado autónomo del módulo (excluye masivos ligados a recepción de compra en servidor), sincronización offline y pantallas de detalle/edición.

Documentación de producto: [`finca_app_docs/user_histories/uh-evento-masivo-lista.md`](../../../../../../finca_app_docs/user_histories/uh-evento-masivo-lista.md), [`finca_app_docs/mejoras/mejora-evento-masivo-lista.md`](../../../../../../finca_app_docs/mejoras/mejora-evento-masivo-lista.md).

---

## Estructura

| Ruta | Rol |
|------|-----|
| `pages/massive_event_list_page.dart` | Entrada **lista** `/massive-events`: web (`MassiveEventListWeb`) vs móvil (`MassiveEventListMobile`), permisos bitmask, filtros y paginación servidor en web. |
| `pages/massive_event_page.dart` | Pantalla de creación / sesión de evento (bloc + formularios). |
| `pages/massive_event_sync_listener*.dart` | Hooks de sincronización según plataforma. |
| `services/massive_event_api_service.dart` | Cliente HTTP hacia `massive-events` (crear, cerrar, listado paginado, etc.). |
| `models/` | `MassiveEventModel` (incluye `linkedToPurchaseReception`, `createdByUsername`), `SimpleEventModel`, `AnimalSimpleEventModel`, tipos. |
| `bloc/` | `MassiveEventBloc` y estados/eventos de la pantalla de evento. |
| `widgets/` | Formularios de evento, tabla de animales, paneles de configuración. |
| `data/massive_event_page_data_source*.dart` | Abstracción de persistencia/API por plataforma (móvil vs web). |

Los data sources concretos viven bajo `lib/modules/mobile/data/massive_event/` y `lib/modules/web/data/massive_event/` (no en esta carpeta).

---

## API HTTP (`MassiveEventApiService`)

Base path: `{apiBaseUrl}/massive-events` (y otros recursos como `simple-events`, `cattle/apply-events` según método).

| Método estático | Uso |
|-----------------|-----|
| `createMassiveEvent` | `POST /massive-events` — creación inicial con `simpleEvents`. |
| `listStandaloneMassiveEventsPaged` | `GET /massive-events` con query `page`, `limit`, `from`, `to`, `name`, `status`. Respuesta **`PagedResponseDto`**: `items`, `page`, `limit`, `total`, `hasMore`. Devuelve `MassiveEventsPageResult`. |
| `listStandaloneMassiveEvents` | Concatena páginas con `limit=500` hasta `hasMore == false` (tope de páginas de seguridad). Acepta los mismos filtros opcionales `from` / `to` / `name` / `status` en **cada** petición (alineado con el backend). |
| `closeMassiveEvent` | `PUT /massive-events/close/:id` — 204 esperado. |
| `createSimpleEvent` | `POST /simple-events` |
| `saveAnimalSimpleEvents` | `POST /cattle/apply-events/:cattleNumber` |
| `updateSimpleEvent` | `PUT` genérico según `endpoint` |

Errores de red hacia el listado: `ApiException` con `serverConnectionError` / `readingObjectError`. Cuerpo de listado que no sea un objeto JSON map → `readingObjectError`.

---

## Lista (`MassiveEventListPage`)

- **Rutas:** típicamente `/massive-events` (stack completo) y panel embebido desde home con `embedded: true`.
- **Permisos:** bitmask entidad `massive_events` bajo módulo `MASSIVE_EVENTS`; helpers en `route_access.dart` (`massiveEventsBitmaskAllowsList`, `massiveEventsBitmaskAllowsCreate`).

### Web (`kIsWeb`)

- Patrón visual alineado con compras: `FincaScaffold`, `Card` de filtros, `DataTable`, `MessageBanner`, paginación inferior.
- **Paginación y filtros en servidor:** cada `_load` llama a `listStandaloneMassiveEventsPaged` con `page`, `limit`, fechas (`yyyy-MM-dd`), texto `name`, `status` (`all` \| `open` \| `closed`).
- Fechas en UI no disparan solas la petición (como compras): **Actualizar**, cambio de **estado**, **Enter** en búsqueda, cambio de tamaño de página o flechas anterior/siguiente.
- Columnas: fecha evento, nombre o id, actualizado, estado (chip), **creado por** (prioriza `createdByUsername` del API), creado, columna sync “Servidor”.

### Móvil (`!kIsWeb`)

- Lista tipo `ListTile` con la misma información relevante que la tabla web; **filtros** equivalentes (fechas, nombre/id, estado) y acciones **Aplicar filtros** / **Limpiar** según implementación actual.
- Carga vía `listStandaloneMassiveEvents(...)` con filtros en query; si hay `fetchStandaloneOverride` en tests, los filtros se aplican en cliente con `_filterMassiveEventsClient` (misma semántica que el API).

### Tests

- `fetchStandaloneOverride`: solo **móvil** — devuelve `Future<List<MassiveEventModel>>`.
- `fetchStandalonePagedOverride`: solo **web** — misma firma que `listStandaloneMassiveEventsPaged` agregada al typedef `MassiveEventsStandalonePagedFetch`.

---

## Modelo `MassiveEventModel`

- `linkedToPurchaseReception`: sincronizado con backend/Drift para excluir recepciones donde corresponda.
- `createdByUsername`: opcional; lo rellena el API en listados y detalle para mostrar usuario legible (el campo `createdBy` sigue siendo uuid).

---

## Pruebas automatizadas (referencia)

- `test/modules/shared/features/massiveEvent/services/massive_event_api_service_test.dart`
- `test/modules/shared/features/massiveEvent/pages/massive_event_list_page_test.dart`
- `test/modules/shared/features/massiveEvent/pages/massive_event_list_router_test.dart`
- Integración: `test/integration/massive_events_list_main_app_test.dart`, `integration_test/massive_events_list_module_integration_test.dart`

---

## Backend relacionado

[`finca_app_backend/src/modules/massive-events/README.md`](../../../../../../finca_app_backend/src/modules/massive-events/README.md).
