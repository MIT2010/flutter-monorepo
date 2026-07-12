import 'package:flutter/foundation.dart';

import 'crash_reporter.dart';

/// Wires [CrashReporter] into Flutter's two global error hooks (§27) — call
/// once from each `main_<flavor>.dart`, right after `configureDependencies`
/// and before `runApp`:
/// ```dart
/// await configureDependencies(env: Env.current);
/// wireCrashReporting(getIt<CrashReporter>());
/// runApp(const App());
/// ```
///
/// Both hooks matter, not just one — a common gap is wiring only
/// [FlutterError.onError], which catches errors the Flutter *framework*
/// itself throws during build/layout/paint (a bad `build()`, a failed
/// assertion), but never sees an error thrown from outside that path
/// (an uncaught `Future` with no `.catchError`, an isolate error). Those
/// go through [PlatformDispatcher.onError] instead — wiring only the
/// first genuinely misses a real class of crash, not a hypothetical one.
void wireCrashReporting(CrashReporter crashReporter) {
  FlutterError.onError = (details) {
    crashReporter.recordError(
      details.exception,
      details.stack ?? StackTrace.empty,
      fatal: true,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    crashReporter.recordError(error, stack, fatal: true);
    return true;
  };
}
