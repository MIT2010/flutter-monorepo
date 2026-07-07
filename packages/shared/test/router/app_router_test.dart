import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class _FakeAuthSession implements AuthSession {
  _FakeAuthSession(this._status);
  final AuthSessionStatus _status;

  @override
  AuthSessionStatus get status => _status;

  @override
  Stream<AuthSessionStatus> get statusStream => Stream.value(_status);
}

final _standaloneRoutes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (context, state) => const Scaffold(body: Text('root-page')),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const Scaffold(body: Text('login-page')),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const Scaffold(body: Text('home-page')),
  ),
];

final _roleGuardedRoutes = <RouteBase>[
  GoRoute(
    path: '/home',
    builder: (context, state) => const Scaffold(body: Text('home-page')),
  ),
  AppRoute(
    path: '/admin',
    roles: const ['admin'],
    builder: (context, state) => const Scaffold(body: Text('admin-page')),
  ),
];

final _shellDestinations = const [
  AppShellDestination(path: '/home', icon: Icons.home, label: 'Home'),
  AppShellDestination(path: '/profile', icon: Icons.person, label: 'Profile'),
];

final _shellRoutes = <RouteBase>[
  GoRoute(path: '/home', builder: (context, state) => const Text('home-tab')),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const Text('profile-tab'),
  ),
];

void main() {
  group('AppRouter redirect', () {
    testWidgets('redirects an unauthenticated user to /login', (
      tester,
    ) async {
      final appRouter = AppRouter(_FakeAuthSession(AuthSessionStatus.unauthenticated))
        ..standaloneRoutes = _standaloneRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      await tester.pumpAndSettle();

      expect(find.text('login-page'), findsOneWidget);
    });

    testWidgets('does not redirect an authenticated user off the requested route', (
      tester,
    ) async {
      final appRouter = AppRouter(
        _FakeAuthSession(const AuthSessionStatus(isAuthenticated: true)),
      )..standaloneRoutes = _standaloneRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      await tester.pumpAndSettle();

      expect(find.text('root-page'), findsOneWidget);
    });

    testWidgets('redirects an authenticated user away from /login', (
      tester,
    ) async {
      final appRouter = AppRouter(
        _FakeAuthSession(const AuthSessionStatus(isAuthenticated: true)),
      )..standaloneRoutes = _standaloneRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      appRouter.router.go('/login');
      await tester.pumpAndSettle();

      expect(find.text('home-page'), findsOneWidget);
      expect(find.text('login-page'), findsNothing);
    });

    testWidgets('falls back to NotFoundPage for an unmatched route', (
      tester,
    ) async {
      final appRouter = AppRouter(
        _FakeAuthSession(const AuthSessionStatus(isAuthenticated: true)),
      )..standaloneRoutes = _standaloneRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      appRouter.router.go('/nowhere');
      await tester.pumpAndSettle();

      expect(find.text('Page not found'), findsOneWidget);
    });
  });

  group('AppRouter role guard', () {
    testWidgets('redirects away from a role-guarded route when the user lacks the role', (
      tester,
    ) async {
      final appRouter = AppRouter(
        _FakeAuthSession(
          const AuthSessionStatus(isAuthenticated: true, roles: ['user']),
        ),
      )..standaloneRoutes = _roleGuardedRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      appRouter.router.go('/admin');
      await tester.pumpAndSettle();

      expect(find.text('home-page'), findsOneWidget);
      expect(find.text('admin-page'), findsNothing);
    });

    testWidgets('allows a role-guarded route when the user has the role', (
      tester,
    ) async {
      final appRouter = AppRouter(
        _FakeAuthSession(
          const AuthSessionStatus(isAuthenticated: true, roles: ['admin']),
        ),
      )..standaloneRoutes = _roleGuardedRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      appRouter.router.go('/admin');
      await tester.pumpAndSettle();

      expect(find.text('admin-page'), findsOneWidget);
    });
  });

  group('AppRouter shell (persistent bottom nav)', () {
    testWidgets('shows a bottom nav bar with the given shell destinations', (
      tester,
    ) async {
      final appRouter = AppRouter(
        _FakeAuthSession(const AuthSessionStatus(isAuthenticated: true)),
      )
        ..standaloneRoutes = [
          GoRoute(
            path: '/login',
            builder: (context, state) =>
                const Scaffold(body: Text('login-page')),
          ),
        ]
        ..shellDestinations = _shellDestinations
        ..shellRoutes = _shellRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      appRouter.router.go('/home');
      await tester.pumpAndSettle();

      expect(find.text('home-tab'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('switches tabs when a destination is tapped', (tester) async {
      final appRouter = AppRouter(
        _FakeAuthSession(const AuthSessionStatus(isAuthenticated: true)),
      )
        ..standaloneRoutes = [
          GoRoute(
            path: '/login',
            builder: (context, state) =>
                const Scaffold(body: Text('login-page')),
          ),
        ]
        ..shellDestinations = _shellDestinations
        ..shellRoutes = _shellRoutes;

      await tester.pumpWidget(MaterialApp.router(routerConfig: appRouter.router));
      appRouter.router.go('/home');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('profile-tab'), findsOneWidget);
      expect(find.text('home-tab'), findsNothing);
    });
  });
}
