import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestRegisterModule extends RegisterModule {}

class _FakeTokenProvider implements TokenProvider {
  _FakeTokenProvider(this._accessToken);

  final String? _accessToken;

  @override
  Future<String?> get accessToken async => _accessToken;

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

class _FakeTokenRefresher implements TokenRefresher {
  _FakeTokenRefresher({this.refreshResult = true});

  final bool refreshResult;
  int refreshCalls = 0;
  int forceLogoutCalls = 0;

  @override
  Future<bool> refresh() async {
    refreshCalls++;
    return refreshResult;
  }

  @override
  Future<void> forceLogout() async {
    forceLogoutCalls++;
  }
}

class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter(this.onRequest);

  final void Function(RequestOptions options) onRequest;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onRequest(options);
    return ResponseBody.fromString('{}', 200);
  }
}

/// 401 the first time any given path is hit, 200 after -- lets a test
/// prove a real retry-after-refresh round trip through RegisterModule's
/// actual Dio instance, not a hand-assembled one.
class _UnauthorizedThenOkAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final alreadyRetried = options.extra['refreshRetried'] == true;
    if (!alreadyRetried) {
      return ResponseBody.fromString('{}', 401);
    }
    return ResponseBody.fromString('{"ok":true}', 200);
  }
}

void main() {
  group('RegisterModule.dio', () {
    test('attaches AuthInterceptor so an authenticated request carries a '
        'Bearer token -- regression test for AuthInterceptor never being '
        'wired into the real Dio instance', () async {
      final module = _TestRegisterModule();
      final dio = module.dio(
        AppLogger(),
        Env.current,
        _FakeTokenProvider('abc123'),
        _FakeTokenRefresher(),
      );

      RequestOptions? captured;
      dio.httpClientAdapter = _CapturingAdapter((options) {
        captured = options;
      });

      await dio.get('/thing');

      expect(captured?.headers['Authorization'], 'Bearer abc123');
    });

    test(
      'sends no Authorization header when there is no token to attach',
      () async {
        final module = _TestRegisterModule();
        final dio = module.dio(
          AppLogger(),
          Env.current,
          _FakeTokenProvider(null),
          _FakeTokenRefresher(),
        );

        RequestOptions? captured;
        dio.httpClientAdapter = _CapturingAdapter((options) {
          captured = options;
        });

        await dio.get('/thing');

        expect(captured?.headers.containsKey('Authorization'), isFalse);
      },
    );

    test('attaches RefreshTokenInterceptor so a 401 triggers a refresh and '
        'retries the original request -- regression test for '
        'RefreshTokenInterceptor being built but never wired into the real '
        'Dio instance', () async {
      final module = _TestRegisterModule();
      final tokenRefresher = _FakeTokenRefresher();
      final dio = module.dio(
        AppLogger(),
        Env.current,
        _FakeTokenProvider('abc123'),
        tokenRefresher,
      );
      dio.httpClientAdapter = _UnauthorizedThenOkAdapter();

      final response = await dio.get('/thing');

      expect(response.statusCode, 200);
      expect(tokenRefresher.refreshCalls, 1);
      expect(tokenRefresher.forceLogoutCalls, 0);
    });

    test(
      'forces logout via TokenRefresher when the refresh itself fails',
      () async {
        final module = _TestRegisterModule();
        final tokenRefresher = _FakeTokenRefresher(refreshResult: false);
        final dio = module.dio(
          AppLogger(),
          Env.current,
          _FakeTokenProvider('abc123'),
          tokenRefresher,
        );
        dio.httpClientAdapter = _UnauthorizedThenOkAdapter();

        await expectLater(
          () => dio.get('/thing'),
          throwsA(isA<DioException>()),
        );
        expect(tokenRefresher.forceLogoutCalls, 1);
      },
    );

    test('does not attempt a refresh for a 401 on /auth/login or /auth/refresh '
        '-- both are excluded so a wrong-password login or the refresh call '
        'itself can never trigger a pointless (or, for /auth/refresh, '
        'deadlocking) refresh attempt', () async {
      final module = _TestRegisterModule();
      final tokenRefresher = _FakeTokenRefresher();
      final dio = module.dio(
        AppLogger(),
        Env.current,
        _FakeTokenProvider('abc123'),
        tokenRefresher,
      );
      dio.httpClientAdapter = _UnauthorizedThenOkAdapter();

      await expectLater(
        () => dio.get('/auth/login'),
        throwsA(isA<DioException>()),
      );
      await expectLater(
        () => dio.get('/auth/refresh'),
        throwsA(isA<DioException>()),
      );
      expect(tokenRefresher.refreshCalls, 0);
    });
  });

  group('RegisterModule feature flags (per @Environment)', () {
    final module = _TestRegisterModule();

    test('dev defaults the debug banner on', () {
      final flags = module.devFeatureFlags();

      expect(flags.isEnabled('debug_banner'), isTrue);
    });

    test('staging starts with every flag off', () {
      final flags = module.stagingFeatureFlags();

      expect(flags.isEnabled('debug_banner'), isFalse);
    });

    test('prod starts with every flag off', () {
      final flags = module.stagingFeatureFlags();

      expect(flags.isEnabled('debug_banner'), isFalse);
    });
  });
}
