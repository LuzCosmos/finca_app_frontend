import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';

import '../../../../../support/app_test_host.dart';

/// Golden opcional D5: panel de filtros expandido (ExpansionTile + hit-test).
///
/// PNG: `goldens/massive_event_list_d5_filters_expanded.png`. Regenerar y notas
/// de plataforma (Linux vs macOS): `docs/correr-tests.md` §Goldens lista masivos D5.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
  });

  MassiveEventModel sample({String id = 'e1', String name = 'Golden'}) {
    return MassiveEventModel(
      id: id,
      eventDate: DateTime(2024, 5, 1),
      simpleEvents: const [],
      name: name,
      createdAt: DateTime(2024, 5, 1),
      updatedAt: DateTime(2024, 5, 2),
    );
  }

  Future<void> savePerms(String bitmask) async {
    await SessionService.saveSession(
      token: 't',
      permissions: {
        'MASSIVE_EVENTS': {'massive_events': bitmask},
      },
      idTenant: 'tid',
      idUser: 'u',
    );
  }

  testWidgets('D5 golden: filtros expandidos', (tester) async {
    await savePerms('10001');
    await tester.pumpWidget(
      pumpLocalizedMaterialShell(
        home: Center(
          child: RepaintBoundary(
            key: const Key('massive-list-d5-golden'),
            child: SizedBox(
              width: 480,
              height: 900,
              child: MassiveEventListPage(
                embedded: true,
                fetchStandaloneOverride:
                    () async => [sample(name: 'Golden lista')],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byKey(const Key('massive-list-d5-golden'))),
    )!;
    await tester.tap(find.text(l10n.massiveEventsListFiltersTitle));
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('massive-list-d5-golden')),
      matchesGoldenFile('goldens/massive_event_list_d5_filters_expanded.png'),
    );
  });
}
