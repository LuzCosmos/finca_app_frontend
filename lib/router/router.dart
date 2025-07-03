import 'package:go_router/go_router.dart';
import '../modules/shared/features/auth/login_page.dart';
import '../modules/shared/features/home/home_page.dart';
import '../modules/shared/features/loading/loading_page.dart';
import '../modules/web/features/cattle_purchase/views/purchase_form_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/loading', // temporal, ahora lo explico abajo
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/cattle-purchase',
      builder: (context, state) => const PurchaseFormPage(),
    ),
    GoRoute(
      path: '/loading', // pantalla inicial mientras decidimos a dónde ir
      builder: (context, state) => const LoadingPage(),
    ),
  ],
  redirect: (context, state) => null,
);
