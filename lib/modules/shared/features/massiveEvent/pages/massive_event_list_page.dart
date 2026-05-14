import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

import 'massive_event_list_mobile_page.dart';
import 'massive_event_list_types.dart';
import 'massive_event_list_web_page.dart';

export 'massive_event_list_types.dart';

/// Lista de eventos masivos (excluye recepciones en servidor). Punto de entrada del módulo.
///
/// En **web** (`kIsWeb`) el layout sigue el patrón de
/// [PurchasesListPage]: `FincaScaffold`, botón **Crear** con
/// `FilledButton.icon` alineado a la derecha (también en panel embebido),
/// filtros en `Card`, tabla `DataTable`
/// con scroll horizontal y paginación **en servidor** (`page`, `limit`, filtros
/// en query). En **móvil** se usa `ListTile` con la **misma información** que
/// la tabla web y **filtros** (fechas, nombre/id, estado) equivalentes a web.
class MassiveEventListPage extends StatelessWidget {
  const MassiveEventListPage({
    super.key,
    this.embedded = false,
    this.fetchStandaloneOverride,
    this.fetchStandalonePagedOverride,
    this.getPermissionsOverride,
  });

  final bool embedded;

  /// Solo para tests **móvil**: sustituye la lista autónoma (todas las páginas agregadas).
  final Future<List<MassiveEventModel>> Function()? fetchStandaloneOverride;

  /// Solo para tests **web**: sustituye el GET paginado.
  final MassiveEventsStandalonePagedFetch? fetchStandalonePagedOverride;

  /// Tests o inyección: sustituye [SessionService.getPermissions] (D3 / fase 7).
  final MassiveEventsGetPermissions? getPermissionsOverride;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MassiveEventListWeb(
        embedded: embedded,
        fetchStandalonePagedOverride: fetchStandalonePagedOverride,
        getPermissionsOverride: getPermissionsOverride,
      );
    }
    return MassiveEventListMobile(
      embedded: embedded,
      fetchStandaloneOverride: fetchStandaloneOverride,
      getPermissionsOverride: getPermissionsOverride,
    );
  }
}
