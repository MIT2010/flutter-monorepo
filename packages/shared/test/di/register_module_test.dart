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
        );

        RequestOptions? captured;
        dio.httpClientAdapter = _CapturingAdapter((options) {
          captured = options;
        });

        await dio.get('/thing');

        expect(captured?.headers.containsKey('Authorization'), isFalse);
      },
    );
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
      final flags = module.prodFeatureFlags();

      expect(flags.isEnabled('debug_banner'), isFalse);
    });
  });
}
