import 'package:core/core.dart';

import '../entities/user.dart';

/// Abstract contract (§18) — the domain layer defines *what* the app does,
/// never *how*. Implemented by [AuthRepositoryImpl] in the data layer.
abstract class AuthRepository {
  Future<Result<Failure, User>> login({
    required String email,
    required String password,
  });
  Future<Result<Failure, void>> logout();
  Future<User?> getCachedUser();

  /// Calls `/auth/refresh` with the stored refresh token and saves the new
  /// tokens on success. Reactive-only — [TokenRefresher]'s contract, only
  /// ever called by [RefreshTokenInterceptor] on a real 401 — so this
  /// stays a bare `bool`, not a typed [Failure]: the interceptor only
  /// needs to know whether to retry the original request or force logout.
  Future<bool> refreshToken();
}
