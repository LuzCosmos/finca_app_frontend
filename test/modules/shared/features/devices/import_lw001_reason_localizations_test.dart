import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/utils/import_lw001_reason_localizations.dart';

import '../../../../support/app_test_host.dart';

void main() {
  testWidgets('maps known import reason codes to l10n', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      ImportLw001ReasonLocalizations.message(l10n, 'IMPORT_HEADERS_INVALID'),
      l10n.importLw001_reason_IMPORT_HEADERS_INVALID,
    );
    expect(
      ImportLw001ReasonLocalizations.message(l10n, 'DEVEUI_INVALID_LENGTH'),
      isNotEmpty,
    );
    expect(
      ImportLw001ReasonLocalizations.message(
        l10n,
        'CHIRPSTACK_PROFILE_ID_REQUIRED',
      ),
      l10n.importLw001_reason_CHIRPSTACK_PROFILE_ID_REQUIRED,
    );
    expect(
      ImportLw001ReasonLocalizations.message(l10n, 'UNKNOWN_CODE'),
      contains('UNKNOWN_CODE'),
    );
  });
}
