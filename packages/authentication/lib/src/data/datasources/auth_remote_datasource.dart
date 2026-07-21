import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../models/token_pair_model.dart';
import '../models/user_model.dart';

/// §19 — talks to `/auth/login`/`/auth/refresh` through `core`'s one Dio
/// instance. Throws nothing itself; [ApiClient] already converts
/// [DioException] into a typed [Failure] before this ever sees it.
@injectable
class AuthRemoteDataSource {
  final ApiClient _client;
  AuthRemoteDataSource(this._client);

  Future<Result<Failure, UserModel>> login(String email, String password) {
    return _client.post(
      '/auth/login',
      data: {'email': email, 'password': password},
      parser: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// [RefreshTokenInterceptor]'s `excludedPaths` (`shared`'s
  /// `RegisterModule.dio`) keeps this specific path out of the retry
  /// cycle it would otherwise trigger on its own 401.
  Future<Result<Failure, TokenPairModel>> refresh(String refreshToken) {
    return _client.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
      parser: (json) => TokenPairModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
