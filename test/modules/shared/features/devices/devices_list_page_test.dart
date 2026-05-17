import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_list_item_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/pages/devices_list_page.dart';

import '../../../../support/app_test_host.dart';

void main() {
  group('DevicesListPage', () {
    testWidgets('empty state when no devices', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return DevicesListPage(
                fetchListOverride: () async => [],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(l10n.devicesList_emptyTitle), findsOneWidget);
      expect(find.text(l10n.devicesList_emptyMessage), findsOneWidget);
    });

    testWidgets('shows rows and filters locally by name', (tester) async {
      const items = [
        DeviceListItemModel(
          id: '1',
          name: 'Alpha Collar',
          deveui: '0102030405060708',
          isActive: true,
          batteryStatus: '80%',
          deviceProfileName: 'LW001',
        ),
        DeviceListItemModel(
          id: '2',
          name: 'Beta Collar',
          deveui: 'aabbccddeeff0011',
          isActive: false,
        ),
      ];

      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return DevicesListPage(fetchListOverride: () async => items);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Alpha Collar'), findsOneWidget);
      expect(find.text('Beta Collar'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'alpha');
      await tester.pump();

      expect(find.text('Alpha Collar'), findsOneWidget);
      expect(find.text('Beta Collar'), findsNothing);
      expect(find.byType(Chip), findsWidgets);
    });

    testWidgets('error state shows retry', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context)!;
              return DevicesListPage(
                fetchListOverride: () async {
                  throw Exception('network');
                },
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(l10n.devicesList_errorGeneric), findsOneWidget);
      expect(find.text(l10n.devicesList_retry), findsOneWidget);
    });
  });
}
