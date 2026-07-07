// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:feature_home/src/data/datasources/home_local_datasource.dart'
    as _i705;
import 'package:feature_home/src/data/datasources/home_remote_datasource.dart'
    as _i951;
import 'package:feature_home/src/data/models/home_item_model.dart' as _i1043;
import 'package:feature_home/src/data/repositories/home_repository_impl.dart'
    as _i670;
import 'package:feature_home/src/di/register_module.dart' as _i313;
import 'package:feature_home/src/domain/repositories/home_repository.dart'
    as _i208;
import 'package:feature_home/src/presentation/cubit/home_cubit.dart' as _i394;
import 'package:hive_ce/hive_ce.dart' as _i1055;
import 'package:hive_ce_flutter/hive_ce_flutter.dart' as _i965;
import 'package:injectable/injectable.dart' as _i526;

class FeatureHomePackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i965.Box<_i1043.HomeItemModel>>(
      () => registerModule.homeItemsBox,
      preResolve: true,
    );
    gh.factory<_i705.HomeLocalDataSource>(
      () => _i705.HomeLocalDataSource(gh<_i1055.Box<_i1043.HomeItemModel>>()),
    );
    gh.factory<_i951.HomeRemoteDataSource>(
      () => _i951.HomeRemoteDataSource(gh<_i494.ApiClient>()),
    );
    gh.lazySingleton<_i208.HomeRepository>(
      () => _i670.HomeRepositoryImpl(
        gh<_i951.HomeRemoteDataSource>(),
        gh<_i705.HomeLocalDataSource>(),
      ),
    );
    gh.factory<_i394.HomeCubit>(
      () => _i394.HomeCubit(gh<_i208.HomeRepository>()),
    );
  }
}

class _$RegisterModule extends _i313.RegisterModule {}
