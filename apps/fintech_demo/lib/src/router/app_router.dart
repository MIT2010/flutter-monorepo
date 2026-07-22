import 'package:go_router/go_router.dart';

import '../pages/auth/login_page.dart';
import '../pages/auth/onboarding_page.dart';
import '../pages/auth/otp_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/splash_page.dart';
import '../pages/bills/bills_page.dart';
import '../pages/cards/cards_page.dart';
import '../pages/home/home_page.dart';
import '../pages/invest/invest_page.dart';
import '../pages/notifications/notifications_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/transactions/transactions_page.dart';
import '../pages/transfer/transfer_page.dart';
import '../shell/app_shell.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(path: Routes.login, builder: (context, state) => const LoginPage()),
    GoRoute(path: Routes.otp, builder: (context, state) => const OtpPage()),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const RegisterPage(),
    ),

    // Top-level tabs -- each wrapped in AppShell so the bottom nav /
    // sidebar stays visible and highlights the right destination.
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: Routes.cards,
          builder: (context, state) => const CardsPage(),
        ),
        GoRoute(
          path: Routes.invest,
          builder: (context, state) => const InvestPage(),
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),

    // Pushed on top of a tab (`context.push`), not part of the shell --
    // each of these is a focused flow, not a tab of its own.
    GoRoute(
      path: Routes.transfer,
      builder: (context, state) => const TransferPage(),
    ),
    GoRoute(path: Routes.bills, builder: (context, state) => const BillsPage()),
    GoRoute(
      path: Routes.transactions,
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: Routes.notifications,
      builder: (context, state) => const NotificationsPage(),
    ),
  ],
);
