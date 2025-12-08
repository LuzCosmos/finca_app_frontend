import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/modules/shared/features/auth/page/login_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/page/home_page.dart';
import 'package:finca_app_frontend/modules/shared/features/loading/loading_page.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/pages/sale_dashboard_page_export.dart';
import 'package:finca_app_frontend/modules/web/features/sales/pages/create_sale_page_web.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchase_form_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';

// Conditional imports para data source específico de plataforma
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/data/massive_event/massive_event_page_data_source_mobile_interface.dart'
    if (dart.library.html) 'package:finca_app_frontend/modules/web/data/massive_event/massive_event_page_data_source_web_interface.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/cattle-purchase',
      builder: (context, state) => const PurchaseFormPage(),
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
    ), //ruta de espera
    GoRoute(
      path: '/massive-event',
      builder: (context, state) {
        final dataSource = createMassiveEventPageDataSource();
        return BlocProvider(
          create: (_) => MassiveEventBloc(dataSource: dataSource),
          child: const MassiveEventPage(),
        );
      },
    ),
  ],
  redirect: (context, state) async {
    final bool loggedIn = await SessionService.hasValidToken();
    final bool loggingIn = state.uri.path == '/login';
    final bool loading = state.uri.path == '/loading';

    if (!loggedIn && !loggingIn && !loading) {
      return '/login';
    }
    if (loggedIn && loggingIn) {
      return '/home';
    }
    return null;
  },
);
