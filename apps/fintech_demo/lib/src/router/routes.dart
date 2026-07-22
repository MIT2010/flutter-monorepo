/// Route path constants -- shared between `app_router.dart` and every
/// page that navigates, so a path never has to be retyped (and risk a
/// typo) at each call site.
class Routes {
  const Routes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const register = '/register';

  static const home = '/home';
  static const cards = '/cards';
  static const invest = '/invest';
  static const profile = '/profile';

  static const transfer = '/transfer';
  static const bills = '/bills';
  static const transactions = '/transactions';
  static const notifications = '/notifications';
  static const settings = '/settings';
}
