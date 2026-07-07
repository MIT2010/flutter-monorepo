import 'package:authentication/authentication.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

/// The composition root's widget (§13, §17): wires `AppRouter` (from
/// `shared`) into `MaterialApp.router`, themed from `design_system`.
///
/// `feature_home` doesn't exist yet, so `/home` is a bare placeholder
/// defined right here rather than a real feature — it exists only so the
/// authenticated branch of `AppRouter`'s redirect has somewhere to land.
/// Deleting this file's placeholder route is the entire diff needed once
/// `feature_home` ships.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>()..standaloneRoutes = _routes;

    return MaterialApp.router(
      title: 'Flutter Starter Kit',
      routerConfig: appRouter.router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
    );
  }
}

final _routes = <RouteBase>[
  GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  GoRoute(path: '/home', builder: (context, state) => const _PlaceholderHomePage()),
];

class _PlaceholderHomePage extends StatelessWidget {
  const _PlaceholderHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Home (feature_home coming soon)'),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Log out',
                onPressed: () async {
                  await getIt<AuthRepository>().logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
