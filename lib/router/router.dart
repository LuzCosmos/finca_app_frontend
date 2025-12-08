import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/modules/shared/features/auth/page/login_page.dart';
import 'package:finca_app_frontend/modules/shared/features/home/page/home_page.dart';
import 'package:finca_app_frontend/modules/shared/features/loading/loading_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchase_form_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/pages/massive_event_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/pages/purchase_reception_page.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/pages/purchases_list_page.dart';

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
      path: '/purchases',
      name: 'purchasesList',
      builder: (_, __) => const PurchasesListPage(),
    ),
    GoRoute(
      path: '/purchases/pending',
      name: 'purchasesPending',
      builder: (_, __) => const PurchasesListPage(initialStatusFilter: 'open'),
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
    GoRoute(
      path: '/purchase/reception/:purchaseId',
      name: 'purchaseReception',
      builder: (context, state) {
        final id = state.pathParameters['purchaseId']!;
        return PurchaseReceptionPage(purchaseId: id);
      },
    ),
  ],
  redirect: (context, state) => null,
);
