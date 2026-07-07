// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core/core.dart' as _i494;
import 'package:core/src/di/core_module.module.dart' as _i363;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../analytics/analytics_service.dart' as _i726;
import '../crash/crash_reporter.dart' as _i272;
import '../flags/feature_flags.dart' as _i773;
import '../router/app_router.dart' as _i81;
import '../router/auth_session.dart' as _i778;
import 'register_module.dart' as _i291;

const String _dev = 'dev';
const String _staging = 'staging';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i363.CorePackageModule().init(gh);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i272.CrashReporter>(() => _i272.NoopCrashReporter());
    gh.lazySingleton<_i778.AuthSession>(
      () => _i778.UnauthenticatedAuthSession(),
    );
    gh.lazySingleton<_i773.FeatureFlags>(
      () => registerModule.devFeatureFlags(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i773.FeatureFlags>(
      () => registerModule.stagingFeatureFlags(),
      registerFor: {_staging},
    );
    gh.lazySingleton<_i726.AnalyticsService>(
      () => _i726.NoopAnalyticsService(),
    );
    gh.lazySingleton<_i81.AppRouter>(
      () => _i81.AppRouter(gh<_i778.AuthSession>()),
    );
    gh.lazySingleton<_i773.FeatureFlags>(
      () => registerModule.prodFeatureFlags(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i494.AppLogger>(), gh<_i494.Env>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
