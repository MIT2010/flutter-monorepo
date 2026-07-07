// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:authentication/src/data/datasources/auth_remote_datasource.dart'
    as _i398;
import 'package:authentication/src/data/datasources/secure_token_storage.dart'
    as _i53;
import 'package:authentication/src/data/repositories/auth_repository_impl.dart'
    as _i556;
import 'package:authentication/src/di/register_module.dart' as _i393;
import 'package:authentication/src/domain/repositories/auth_repository.dart'
    as _i279;
import 'package:authentication/src/domain/usecases/login_usecase.dart' as _i651;
import 'package:authentication/src/presentation/cubit/login_cubit.dart'
    as _i689;
import 'package:core/core.dart' as _i494;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared/shared.dart' as _i811;

class AuthenticationPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.flutterSecureStorage);
    gh.lazySingleton<_i53.SecureTokenStorage>(
        () => _i53.SecureTokenStorage(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i494.TokenProvider>(
        () => registerModule.tokenProvider(gh<_i53.SecureTokenStorage>()));
    gh.factory<_i398.AuthRemoteDataSource>(
        () => _i398.AuthRemoteDataSource(gh<_i494.ApiClient>()));
    gh.lazySingleton<_i279.AuthRepository>(() => _i556.AuthRepositoryImpl(
          gh<_i398.AuthRemoteDataSource>(),
          gh<_i53.SecureTokenStorage>(),
        ));
    gh.factory<_i651.LoginUseCase>(() => _i651.LoginUseCase(
          gh<_i279.AuthRepository>(),
          gh<_i811.AnalyticsService>(),
        ));
    gh.factory<_i689.LoginCubit>(
        () => _i689.LoginCubit(gh<_i651.LoginUseCase>()));
  }
}

class _$RegisterModule extends _i393.RegisterModule {}
