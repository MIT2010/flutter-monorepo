import 'package:injectable/injectable.dart';

import '../di/app_environment.dart';

/// Wired once in `main_<flavor>.dart`, right after `configureDependencies`
/// and before `runApp` (§27) — see `wireCrashReporting` in this package's
/// `crash/wire_crash_reporting.dart`, the real implementation of what used
/// to just be a doc-comment example here.
abstract class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace stack, {
    bool fatal = false,
  });
  Future<void> setUserId(String? id);
}

/// `staging`/`prod` default, same swap-later pattern as
/// [AnalyticsService]'s [NoopAnalyticsService] — `FirebaseCrashlyticsReporter`
/// behind `@Environment('prod')` later replaces this without touching any
/// call site. [InMemoryCrashReporter] below is `dev`'s genuinely-different
/// implementation, proving that swap actually resolves through `get_it`.
@Environment(AppEnvironment.staging)
@Environment(AppEnvironment.prod)
@LazySingleton(as: CrashReporter)
class NoopCrashReporter implements CrashReporter {
  @override
  Future<void> recordError(
    Object error,
    StackTrace stack, {
    bool fatal = false,
  }) async {}

  @override
  Future<void> setUserId(String? id) async {}
}

/// One recorded `recordError(...)` call — what [NoopCrashReporter]
/// deliberately throws away.
class RecordedCrashError {
  final Object error;
  final StackTrace stack;
  final bool fatal;
  const RecordedCrashError(this.error, this.stack, {required this.fatal});

  @override
  String toString() => 'RecordedCrashError($error, fatal: $fatal)';
}

/// `dev`-only, genuinely-different implementation from [NoopCrashReporter]
/// — remembers every recorded error (`errors`) instead of discarding it,
/// so a developer working locally can actually see what
/// `FlutterError.onError`/`PlatformDispatcher.instance.onError` caught.
/// See `InMemoryAnalyticsService`'s doc comment — same proof, same reason.
@Environment(AppEnvironment.dev)
@LazySingleton(as: CrashReporter)
class InMemoryCrashReporter implements CrashReporter {
  final List<RecordedCrashError> errors = [];
  String? userId;

  @override
  Future<void> recordError(
    Object error,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    errors.add(RecordedCrashError(error, stack, fatal: fatal));
  }

  @override
  Future<void> setUserId(String? id) async {
    userId = id;
  }
}
