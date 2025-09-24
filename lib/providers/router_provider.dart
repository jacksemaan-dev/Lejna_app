import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/admin/admin_dashboard_page.dart';

/// Provides a configured [GoRouter] instance. The router listens to the
/// authentication state and redirects users accordingly. When unauthenticated
/// the user is taken to the login page. Once authenticated they are
/// presented with the home screen. Admin users can also navigate to
/// `/admin` to access administrative dashboards.
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(ref.watch(authProvider.notifier).stream),
    redirect: (context, state) {
      final loggedIn = auth != null;
      final loggingIn = state.subloc == '/login';

      // If not logged in, redirect everything to login.
      if (!loggedIn) return loggingIn ? null : '/login';

      // If logged in and navigating to login, go to home instead.
      if (loggedIn && loggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const MaterialPage(
          key: ValueKey('login'),
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(
          key: ValueKey('home'),
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('admin'),
          child: AdminDashboardPage(),
        ),
      ),
    ],
  );
});

/// A simple helper class to convert a [Stream] into a [ChangeNotifier] that
/// triggers router refreshes. Riverpod’s providers don’t implement
/// Listenable, so we use this adapter when the authentication state
/// changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}