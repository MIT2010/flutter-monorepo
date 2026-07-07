// The generated micro-package modules — not exported through any public
// barrel (they're codegen hooks, not public API), imported directly here
// since this is the one place that aggregates them.
// ignore_for_file: implementation_imports
import 'package:authentication/src/di/authentication_module.module.dart';
import 'package:core/core.dart';
import 'package:core/src/di/core_module.module.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart' hide configureDependencies;
import 'package:shared/src/di/shared_module.module.dart';

import 'injection.config.dart';

/// The app's real composition root (§12). `apps/mobile` is the only
/// package allowed to depend on `core`, `shared` *and* `authentication`
/// at once (§6), so it's the only place that can fold all three
/// packages' micro-package modules into one `get_it` graph.
///
/// `shared`'s own `configureDependencies` (a *different*, non-micro
/// `@InjectableInit`) stays scoped to `shared`'s own test suite — this is
/// the one every `main_<flavor>.dart` actually calls.
@InjectableInit(
  preferRelativeImports: true,
  externalPackageModulesBefore: [
    ExternalModule(CorePackageModule),
    ExternalModule(SharedPackageModule),
    ExternalModule(AuthenticationPackageModule),
  ],
)
Future<void> configureDependencies({required Env env}) async {
  getIt.registerSingleton<Env>(env);
  await getIt.init(environment: env.flavor.name);
}
