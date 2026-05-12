import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart';

import '../../../../../support/app_test_host.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/pages/massive_event_list_page.dart
//   (permisos, vacío, carga, offline, errores, scaffold vs embebido)

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionService.resetForTesting();
  });

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

  MassiveEventModel sample({
    String id = 'e1',
    String? name,
    DateTime? eventDate,
  }) {
    return MassiveEventModel(
      id: id,
      eventDate: eventDate ?? DateTime(2024, 5, 1),
      simpleEvents: const [],
      name: name,
      createdAt: DateTime(2024, 5, 1),
      updatedAt: DateTime(2024, 5, 2),
    );
  }

  group('permisos bitmask', () {
    testWidgets('solo create sin list: mensaje sin permiso de listado', (
      tester,
    ) async {
      await savePerms('10000');
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: const MassiveEventListPage(embedded: true),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(
        tester.element(find.byType(MassiveEventListPage)),
      )!;
      expect(find.text(l10n.massiveEventsNoListPermission), findsOneWidget);
    });

    testWidgets('solo list: sin botón añadir en cabecera embebida', (
      tester,
    ) async {
      await savePerms('00001');
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: () async => [sample()],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.text('e1'), findsOneWidget);
    });

    testWidgets('list + create: icono añadir visible con datos', (
      tester,
    ) async {
      await savePerms('10001');
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: () async => [sample(name: 'Con nombre')],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Con nombre'), findsOneWidget);
    });
  });

  group('estados de datos', () {
    testWidgets('lista vacía: mensaje empty', (tester) async {
      await savePerms('00001');
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: () async => [],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(
        tester.element(find.byType(MassiveEventListPage)),
      )!;
      expect(find.text(l10n.noDataSomething(l10n.massiveEvents)), findsOneWidget);
    });

    testWidgets('varias filas: un ListTile por evento', (tester) async {
      await savePerms('00001');
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride:
                () async => [
                  sample(id: 'a', name: 'A'),
                  sample(id: 'b', name: 'B'),
                ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('sin nombre: título de fila es el id', (tester) async {
      await savePerms('00001');
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride:
                () async => [sample(id: 'uuid-sin-nombre', name: null)],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('uuid-sin-nombre'), findsOneWidget);
    });
  });

  group('carga y layout', () {
    testWidgets('mientras fetch pendiente: indicador de carga', (
      tester,
    ) async {
      await savePerms('00001');
      final completer = Completer<List<MassiveEventModel>>();
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: () => completer.future,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete([]);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('no embebido: scaffold con clave de página', (tester) async {
      await savePerms('00001');
      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: false,
            fetchStandaloneOverride: () async => [],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('massive-event-list-page')),
        findsOneWidget,
      );
    });
  });

  group('red y errores', () {
    testWidgets(
      'fallo de red y luego éxito: offline y lista tras Reintentar',
      (tester) async {
        await savePerms('00001');
        var calls = 0;
        Future<List<MassiveEventModel>> fetch() async {
          calls++;
          if (calls == 1) {
            throw const SocketException('no network');
          }
          return [sample(name: 'Visible')];
        }

        await tester.pumpWidget(
          pumpLocalizedMaterialShell(
            home: MassiveEventListPage(
              embedded: true,
              fetchStandaloneOverride: fetch,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final l10n = AppLocalizations.of(
          tester.element(find.byType(MassiveEventListPage)),
        )!;
        expect(find.text(l10n.massiveEventsListOffline), findsOneWidget);

        await tester.tap(find.text(l10n.retry));
        await tester.pumpAndSettle();

        expect(calls, 2);
        expect(find.text('Visible'), findsOneWidget);
        expect(find.text(l10n.massiveEventsListOffline), findsNothing);
      },
    );

    testWidgets('ApiException serverConnectionError → offline', (
      tester,
    ) async {
      await savePerms('00001');
      Future<List<MassiveEventModel>> fetch() async {
        throw ApiException(ApiExceptionCode.serverConnectionError.name, '');
      }

      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: fetch,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MassiveEventListPage)),
      )!;
      expect(find.text(l10n.massiveEventsListOffline), findsOneWidget);
    });

    testWidgets('ApiException forbidden: error sin offline', (tester) async {
      await savePerms('00001');
      Future<List<MassiveEventModel>> fetch() async {
        throw ApiException(ApiExceptionCode.forbidden.name, '');
      }

      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: fetch,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MassiveEventListPage)),
      )!;
      expect(find.text(l10n.massiveEventsListLoadError), findsOneWidget);
      expect(find.text(l10n.massiveEventsListOffline), findsNothing);
    });

    testWidgets('mensaje con ClientException en toString → offline', (
      tester,
    ) async {
      await savePerms('00001');
      Future<List<MassiveEventModel>> fetch() async {
        throw Exception('ClientException: connection reset');
      }

      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: fetch,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MassiveEventListPage)),
      )!;
      expect(find.text(l10n.massiveEventsListOffline), findsOneWidget);
    });

    testWidgets('error genérico sin señales de red → sin bloque offline', (
      tester,
    ) async {
      await savePerms('00001');
      Future<List<MassiveEventModel>> fetch() async {
        throw Exception('fallo interno');
      }

      await tester.pumpWidget(
        pumpLocalizedMaterialShell(
          home: MassiveEventListPage(
            embedded: true,
            fetchStandaloneOverride: fetch,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(MassiveEventListPage)),
      )!;
      expect(find.text(l10n.massiveEventsListLoadError), findsOneWidget);
      expect(find.text(l10n.massiveEventsListOffline), findsNothing);
    });
  });
}
