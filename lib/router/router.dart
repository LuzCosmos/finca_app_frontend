import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/core/services/auth_service.dart';
import 'package:finca_app_frontend/modules/shared/features/dashboard/page/dashboard_page.dart';
import 'package:finca_app_frontend/modules/shared/features/auth/page/login_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/page/home_page.dart';
import 'package:finca_app_frontend/modules/shared/features/loading/loading_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/sale_dashboard_page_export.dart';
import 'package:finca_app_frontend/modules/web/features/sales/pages/create_sale_page_web.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchase_form_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/pages/purchase_reception_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchases_list_page.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/users/pages/users_list_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/pages/cattle_master_list_page.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/screens/device_remote_config_screen.dart';
import 'package:finca_app_frontend/router/route_access.dart';

// Conditional imports para data source específico de plataforma
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/data/massive_event/massive_event_page_data_source_mobile_interface.dart'
    if (dart.library.html) 'package:finca_app_frontend/modules/web/data/massive_event/massive_event_page_data_source_web_interface.dart';

/// Firma injectable para decidir sesión en tests sin depender del estado
/// estático de [SessionService].
typedef HasValidToken = bool Function();

/// Crea una instancia nueva de [GoRouter] (evita estado compartido entre tests).
/// En producción se usa [appRouter] sin argumentos.
GoRouter createAppRouter({
  HasValidToken? hasValidToken,
  String initialLocation = '/loading',
  AuthService? loginAuthService,
}) {
  final HasValidToken resolveHasValidToken =
      hasValidToken ?? SessionService.hasValidTokenSync;

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(authService: loginAuthService),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/purchases/create',
        builder: (context, state) => const PurchaseFormPage(),
      ),
      GoRoute(
        path: '/purchases',
        name: 'purchasesList',
        builder: (_, _) => const PurchasesListPage(),
      ),
      GoRoute(
        path: '/purchases/pending',
        name: 'purchasesPending',
        builder: (_, _) => const PurchasesListPage(initialStatusFilter: 'open'),
      ),

      GoRoute(
        path: '/sales',
        builder: (context, state) => const SaleDashboardPage(),
      ),
      GoRoute(
        path: '/sales/create',
        builder: (context, state) => const CreateSalePage(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: '/massive-events/create',
        builder: (context, state) {
          final dataSource = createMassiveEventPageDataSource();
          return BlocProvider(
            create: (_) => MassiveEventBloc(dataSource: dataSource),
            child: const MassiveEventPage(),
          );
        },
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UsersListPage(),
      ),
      GoRoute(
        path: '/purchase/reception/:purchaseId',
        name: 'purchaseReception',
        builder: (context, state) {
          final id = state.pathParameters['purchaseId']!;
          return PurchaseReceptionPage(purchaseId: id);
        },
      ),
      GoRoute(
        path: '/cattle',
        builder: (context, state) => const CattleMasterListPage(),
      ),
      GoRoute(
        path: '/devices/:deveui/remote-config',
        name: 'deviceRemoteConfig',
        builder: (context, state) {
          final deveui = state.pathParameters['deveui']!;
          final deviceName = state.uri.queryParameters['name'];
          return DeviceRemoteConfigScreen(
            deveui: deveui,
            deviceName: deviceName,
          );
        },
      ),
    ],
    redirect: (context, state) {
      final bool loggedIn = resolveHasValidToken();
      final String path = state.uri.path;
      final bool loggingIn = path == '/login';
      final bool loading = path == '/loading';

      if (loading) {
        return loggedIn ? '/home' : '/login';
      }

      if (!loggedIn && !loggingIn) {
        return '/login';
      }
      if (loggedIn && loggingIn) {
        return '/home';
      }

      final permissions = SessionService.permissionsSnapshotForRouteGuard;
      if (loggedIn && !loggingIn && !loading && permissions != null) {
        final denied = routeAccessDeniedRedirect(
          path: path,
          permissions: permissions,
        );
        if (denied != null) {
          return denied;
        }
      }
      return null;
    },
  );
}

final GoRouter appRouter = createAppRouter();
