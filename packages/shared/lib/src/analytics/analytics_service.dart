import 'package:injectable/injectable.dart';

import '../di/app_environment.dart';

/// Business logic calls `analyticsService.logEvent(...)` and never knows
/// which provider is live (§17, §26).
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? params});
  Future<void> setUserId(String? id);
}

/// `staging`/`prod` default so the app runs before a real provider has
/// been picked. Later: `@Environment('prod') class
/// FirebaseAnalyticsService implements AnalyticsService {...}` swaps in
/// without touching any call site — everything above the DI registration
/// stays exactly the same, [InMemoryAnalyticsService] below is the proof
/// this actually works today, not just a claim in a comment.
@Environment(AppEnvironment.staging)
@Environment(AppEnvironment.prod)
@LazySingleton(as: AnalyticsService)
class NoopAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {}

  @override
  Future<void> setUserId(String? id) async {}
}

/// One logged `logEvent(...)` call, captured for inspection — what
/// [NoopAnalyticsService] deliberately throws away.
class LoggedAnalyticsEvent {
  final String name;
  final Map<String, Object?>? params;
  const LoggedAnalyticsEvent(this.name, this.params);

  @override
  String toString() => 'LoggedAnalyticsEvent($name, $params)';
}

/// `dev`-only, genuinely-different implementation from
/// [NoopAnalyticsService] — not a second no-op, this one actually
/// remembers what was logged (`events`), so a developer working locally
/// (or a test) can inspect real call history instead of "did this throw."
/// Proves the `@Environment`-scoped swap pattern this package's own doc
/// comments have always promised actually resolves through `get_it`, not
/// just that two classes implementing the same interface happen to exist
/// (`packages/shared/test/di/injection_test.dart`'s
/// `AnalyticsService resolves per environment` group).
@Environment(AppEnvironment.dev)
@LazySingleton(as: AnalyticsService)
class InMemoryAnalyticsService implements AnalyticsService {
  final List<LoggedAnalyticsEvent> events = [];
  String? userId;

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    events.add(LoggedAnalyticsEvent(name, params));
  }

  @override
  Future<void> setUserId(String? id) async {
    userId = id;
  }
}
