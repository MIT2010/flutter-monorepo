import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import 'auth_cubit.dart';
import 'auth_state.dart';

/// The adapter `shared`'s `auth_session.dart` comment promised: `shared` and
/// `authentication` are siblings (§6), so `AppRouter` depends on the thin
/// `AuthSession` contract instead of this package's concrete `AuthCubit` —
/// this is the one place that bridges the two. Registering as
/// `@LazySingleton(as: AuthSession)` supersedes `shared`'s own
/// `UnauthenticatedAuthSession` default registration; `apps/mobile`'s
/// `injection.dart` sets `getIt.allowReassignment = true` so the second
/// registration (this one, since `authentication`'s micro-package module is
/// listed after `shared`'s) is allowed to replace the first instead of
/// asserting.
@LazySingleton(as: AuthSession)
class AuthSessionAdapter implements AuthSession {
  final AuthCubit _authCubit;
  AuthSessionAdapter(this._authCubit);

  @override
  AuthSessionStatus get status => _toStatus(_authCubit.state);

  @override
  Stream<AuthSessionStatus> get statusStream =>
      _authCubit.stream.map(_toStatus);

  // AuthRefreshing maps the same as AuthAuthenticated -- a reactive token
  // refresh in flight is not a logged-out session, and AppRouter must not
  // redirect away from the current screen just because one is happening.
  // Only a genuine failure's later AuthUnauthenticated emission (via
  // AuthCubit.forceLogout) does that.
  AuthSessionStatus _toStatus(AuthState state) => switch (state) {
    AuthAuthenticated(:final user) || AuthRefreshing(:final user) =>
      AuthSessionStatus(isAuthenticated: true, roles: [user.role]),
    AuthInitial() || AuthUnauthenticated() => AuthSessionStatus.unauthenticated,
  };
}
