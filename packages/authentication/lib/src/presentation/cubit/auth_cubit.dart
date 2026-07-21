import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// App-wide session state (§9) — checks the cached user once at boot, and
/// is what [AuthSessionAdapter] (in the same folder) wraps for
/// `AppRouter`'s redirect logic. `@lazySingleton` (not `@injectable`) so
/// [LoginCubit] and the router's `AuthSession` adapter share the exact same
/// instance/stream — logging in has to be visible to both.
///
/// Also implements [TokenRefresher] — bound to that interface too via
/// `authentication`'s `RegisterModule.tokenRefresher`, so
/// `RefreshTokenInterceptor` (built in `shared`, which can't import
/// `authentication`) can call back into the one auth-session owner on a
/// real 401, without a circular package dependency. [refresh] and
/// [forceLogout] are that contract's two methods; [forceLogout] is
/// deliberately just [logout] under another name — a refresh-triggered
/// logout needs the exact same side effects as a user-tapped one.
@lazySingleton
class AuthCubit extends Cubit<AuthState> implements TokenRefresher {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState.initial()) {
    _restoreCachedSession();
  }

  Future<void> _restoreCachedSession() async {
    final user = await _repository.getCachedUser();
    emit(
      user != null
          ? AuthState.authenticated(user)
          : const AuthState.unauthenticated(),
    );
  }

  /// Called by [LoginCubit] right after a successful login — the tokens are
  /// already persisted by [AuthRepositoryImpl.login] by this point, this
  /// just makes the in-memory session (and therefore the router) catch up.
  void setAuthenticated(User user) => emit(AuthState.authenticated(user));

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }

  /// Shows [AuthState.refreshing] while the call is in flight, not
  /// nothing — leaving `state` untouched would make a *successful*
  /// refresh indistinguishable from any other silent background request,
  /// with nothing shown on the current screen while waiting either. Only
  /// [forceLogout] (via `RefreshTokenInterceptor`'s `onRefreshFailed`)
  /// moves to `unauthenticated` — a *failed* refresh is the only thing
  /// that should ever reach `/login`; a successful one restores exactly
  /// the session that was there before, on whatever screen the user was
  /// already on.
  @override
  Future<bool> refresh() async {
    final current = state;
    if (current is! AuthAuthenticated) return _repository.refreshToken();

    emit(AuthState.refreshing(current.user));
    final refreshed = await _repository.refreshToken();
    if (refreshed) {
      emit(AuthState.authenticated(current.user));
    }
    return refreshed;
  }

  @override
  Future<void> forceLogout() => logout();
}
