import 'package:core/core.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/di/injection.config.dart';
import 'package:flutter_test/flutter_test.dart';

/// `shared`'s own `configureDependencies()` is a self-contained
/// composition root for this test suite (unlike `apps/mobile`'s, it never
/// folds in `authentication`'s registrations — see `injection.dart`'s doc
/// comment). `RegisterModule.dio` now needs a `TokenProvider` to attach
/// `AuthInterceptor`, and the only concrete implementation
/// (`SecureTokenStorage`) lives in `authentication`, so this suite has to
/// supply a stand-in itself, the same way `apps/mobile`'s real
/// composition root supplies the real one.
class _FakeTokenProvider implements TokenProvider {
  @override
  Future<String?> get accessToken async => null;

  @override
  Future<String?> get refreshToken async => null;

  @override
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {}

  @override
  Future<void> clear() async {}
}

void main() {
  group('configureDependencies', () {
    setUp(
      () => getIt.registerSingleton<TokenProvider>(_FakeTokenProvider()),
    );
    tearDown(() => getIt.reset());

    test(
      'registers every core + shared service reachable through DI',
      () async {
        await configureDependencies(env: Env.current);

        expect(getIt<Env>(), same(Env.current));
        expect(getIt<AppLogger>(), isA<AppLogger>());
        expect(getIt<ApiClient>(), isA<ApiClient>());
        // Env.current defaults to Flavor.dev in test context (asserted
        // below too) — dev resolves to the in-memory implementations, not
        // Noop. See the "AnalyticsService / CrashReporter resolve per
        // environment" group for staging/prod and for what the in-memory
        // ones actually capture.
        expect(getIt<AnalyticsService>(), isA<InMemoryAnalyticsService>());
        expect(getIt<CrashReporter>(), isA<InMemoryCrashReporter>());
        expect(getIt<FeatureFlags>(), isA<LocalFeatureFlags>());
        expect(getIt<AuthSession>(), isA<UnauthenticatedAuthSession>());
        expect(getIt<AppRouter>(), isA<AppRouter>());
      },
    );

    test(
      'resolves the dev-tagged FeatureFlags when Env.current is dev',
      () async {
        // Env.current defaults to Flavor.dev when no --dart-define is set,
        // which is exactly the case while running tests.
        expect(Env.current.flavor, Flavor.dev);

        await configureDependencies(env: Env.current);

        expect(getIt<FeatureFlags>().isEnabled('debug_banner'), isTrue);
      },
    );

    test('lazy singletons resolve to the same instance every time', () async {
      await configureDependencies(env: Env.current);

      expect(identical(getIt<AppRouter>(), getIt<AppRouter>()), isTrue);
      expect(identical(getIt<ApiClient>(), getIt<ApiClient>()), isTrue);
    });
  });

  // Proves the `@Environment`-scoped swap pattern AnalyticsService's and
  // CrashReporter's own doc comments have always promised actually
  // resolves through get_it — not just that InMemory*/Noop* both happen
  // to exist as classes implementing the same interface. `Env.current` is
  // fixed for the whole test process (its constructor is private, driven
  // by a compile-time --dart-define), so unlike `configureDependencies`
  // above, these call `getIt.init(environment: ...)` directly with each
  // flavor string to actually exercise all three registrations in one run.
  group('AnalyticsService / CrashReporter resolve per environment', () {
    tearDown(() => getIt.reset());

    test('dev resolves to the in-memory implementations', () async {
      await getIt.init(environment: 'dev');

      expect(getIt<AnalyticsService>(), isA<InMemoryAnalyticsService>());
      expect(getIt<CrashReporter>(), isA<InMemoryCrashReporter>());
    });

    test('staging resolves to the Noop implementations', () async {
      await getIt.init(environment: 'staging');

      expect(getIt<AnalyticsService>(), isA<NoopAnalyticsService>());
      expect(getIt<CrashReporter>(), isA<NoopCrashReporter>());
    });

    test('prod resolves to the Noop implementations', () async {
      await getIt.init(environment: 'prod');

      expect(getIt<AnalyticsService>(), isA<NoopAnalyticsService>());
      expect(getIt<CrashReporter>(), isA<NoopCrashReporter>());
    });

    test(
      'InMemoryAnalyticsService genuinely records what was logged — not '
      'just "did not throw" the way NoopAnalyticsService is limited to',
      () async {
        await getIt.init(environment: 'dev');
        final analytics = getIt<AnalyticsService>() as InMemoryAnalyticsService;

        await analytics.logEvent(
          'login_success',
          params: {'method': 'password'},
        );
        await analytics.setUserId('user-1');

        expect(analytics.events, hasLength(1));
        expect(analytics.events.single.name, 'login_success');
        expect(analytics.events.single.params, {'method': 'password'});
        expect(analytics.userId, 'user-1');
      },
    );

    test('InMemoryCrashReporter genuinely records what was reported', () async {
      await getIt.init(environment: 'dev');
      final crashReporter = getIt<CrashReporter>() as InMemoryCrashReporter;
      final error = Exception('boom');

      await crashReporter.recordError(error, StackTrace.current, fatal: true);

      expect(crashReporter.errors, hasLength(1));
      expect(crashReporter.errors.single.error, same(error));
      expect(crashReporter.errors.single.fatal, isTrue);
    });
  });
}
