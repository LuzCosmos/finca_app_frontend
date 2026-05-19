import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Sync móvil global desactivado: sin listener de conectividad ni UI de sync.
class HomeSyncHelper {
  void dispose() {}

  Future<void> onPostFrame(State state) async {}

  Widget buildSyncSection(BuildContext context, AppLocalizations l10n) =>
      const SizedBox.shrink();
}

HomeSyncHelper createHomeSyncHelper() => HomeSyncHelper();
