import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// The app-wide session state (§9) — distinct from [LoginState], which is
/// scoped to the login *screen's* form submission. A union of 4 states, so
/// per ADR-005 this is `sealed class ... with _$AuthState`.
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// A reactive token refresh ([AuthCubit.refresh], `TokenRefresher`'s
  /// contract) is in flight for [user] — carries the exact session that
  /// was live right before the refresh started, not discarded. Distinct
  /// from [AuthAuthenticated] so the UI can show a loading indicator
  /// instead of whatever the current screen's now-paused, stale-request
  /// state would otherwise render; distinct from [AuthUnauthenticated] so
  /// `AppRouter` never redirects away from the current screen just
  /// because a refresh is in flight — only a genuine failure's later
  /// `unauthenticated` emission does that.
  const factory AuthState.refreshing(User user) = AuthRefreshing;
}
