import 'package:injectable/injectable.dart';

/// What [AppRouter] needs to know about first-launch onboarding gating —
/// nothing more. Same cross-package pattern as [AuthSession]: `shared`
/// and a future `feature_onboarding` are siblings in the dependency
/// graph, neither importing the other, so the router depends on this thin
/// contract instead of a concrete onboarding datasource. That feature
/// would adapt its own local flag to this interface, superseding this
/// file's default registration — zero changes needed here when that
/// happens.
abstract class FirstLaunchGate {
  bool get isFirstLaunch;
}

/// Default: nothing gates on first-launch until a real onboarding feature
/// registers its own persisted-flag implementation under this same
/// interface — same swap-later pattern as [UnauthenticatedAuthSession].
@LazySingleton(as: FirstLaunchGate)
class AlwaysCompletedFirstLaunchGate implements FirstLaunchGate {
  @override
  bool get isFirstLaunch => false;
}
