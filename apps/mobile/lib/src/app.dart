import 'package:authentication/authentication.dart';
import 'package:design_system/design_system.dart';
import 'package:feature_home/feature_home.dart';
import 'package:feature_profile/feature_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

/// The composition root's widget (§13, §17): wires `AppRouter` (from
/// `shared`) into `MaterialApp.router`, themed from `design_system`.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>()..standaloneRoutes = _routes;

    // Gates on AuthRefreshing only -- a reactive token refresh
    // (RefreshTokenInterceptor -> AuthCubit.refresh) has nothing to show
    // the user while it's in flight otherwise: AuthSessionAdapter maps it
    // to "still authenticated" so AppRouter never redirects away, but
    // with no gate here the current screen would just render whatever
    // now-stale, paused-request state it already had, with no feedback
    // that anything is happening.
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      builder: (context, state) {
        if (state is AuthRefreshing) {
          return MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp.router(
          title: 'Flutter Starter Kit',
          routerConfig: appRouter.router,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
        );
      },
    );
  }
}

final _routes = <RouteBase>[
  GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  GoRoute(path: '/home', builder: (context, state) => const HomePage()),
  GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
];
