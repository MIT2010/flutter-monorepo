// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:dio/dio.dart' as _i361;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared/src/analytics/analytics_service.dart' as _i760;
import 'package:shared/src/crash/crash_reporter.dart' as _i156;
import 'package:shared/src/di/register_module.dart' as _i840;
import 'package:shared/src/flags/feature_flags.dart' as _i378;
import 'package:shared/src/router/app_router.dart' as _i767;
import 'package:shared/src/router/auth_session.dart' as _i1;

const String _dev = 'dev';
const String _staging = 'staging';
const String _prod = 'prod';

class SharedPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i156.CrashReporter>(() => _i156.NoopCrashReporter());
    gh.lazySingleton<_i1.AuthSession>(() => _i1.UnauthenticatedAuthSession());
    gh.lazySingleton<_i378.FeatureFlags>(
      () => registerModule.devFeatureFlags(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i378.FeatureFlags>(
      () => registerModule.stagingFeatureFlags(),
      registerFor: {_staging},
    );
    gh.lazySingleton<_i760.AnalyticsService>(
        () => _i760.NoopAnalyticsService());
    gh.lazySingleton<_i767.AppRouter>(
        () => _i767.AppRouter(gh<_i1.AuthSession>()));
    gh.lazySingleton<_i378.FeatureFlags>(
      () => registerModule.prodFeatureFlags(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio(
          gh<_i494.AppLogger>(),
          gh<_i494.Env>(),
        ));
  }
}

class _$RegisterModule extends _i840.RegisterModule {}
