import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

class _UnauthorizedThenOkAdapter implements HttpClientAdapter {
  int callCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    final alreadyRetried = options.extra['refreshRetried'] == true;
    if (!alreadyRetried) {
      return ResponseBody.fromString('{}', 401);
    }
    return ResponseBody.fromString('{"ok":true}', 200);
  }
}

/// Every request gets a 401, unconditionally -- models a backend where
/// `/auth/refresh` itself has gone bad (expired refresh token, revoked
/// session), the scenario that used to deadlock [RefreshTokenInterceptor]
/// when [RefreshTokenInterceptor.onRefreshToken] calls back into the same
/// [Dio] instance.
class _AlwaysUnauthorizedAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString('{}', 401);
  }
}

void main() {
  group('RefreshTokenInterceptor', () {
    test('replays the request once after a successful refresh', () async {
      final adapter = _UnauthorizedThenOkAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      var refreshCalls = 0;
      var loggedOut = false;
      dio.interceptors.add(
        RefreshTokenInterceptor(
          dio,
          onRefreshToken: () async {
            refreshCalls++;
            return true;
          },
          onRefreshFailed: () => loggedOut = true,
        ),
      );

      final response = await dio.get('https://api.test/thing');

      expect(response.statusCode, 200);
      expect(refreshCalls, 1);
      expect(loggedOut, isFalse);
      expect(adapter.callCount, 2);
    });

    test('forces logout and rethrows when the refresh itself fails', () async {
      final adapter = _UnauthorizedThenOkAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      var loggedOut = false;
      dio.interceptors.add(
        RefreshTokenInterceptor(
          dio,
          onRefreshToken: () async => false,
          onRefreshFailed: () => loggedOut = true,
        ),
      );

      await expectLater(
        () => dio.get('https://api.test/thing'),
        throwsA(isA<DioException>()),
      );
      expect(loggedOut, isTrue);
    });

    test('does not attempt a refresh for a 401 on an excluded path', () async {
      final adapter = _UnauthorizedThenOkAdapter();
      // A baseUrl + relative path, not a full URL like the tests above --
      // `excludedPaths` matches against `RequestOptions.path`, which only
      // holds the relative segment when a baseUrl is set (the same way
      // `RegisterModule.dio` configures its real Dio instance).
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
        ..httpClientAdapter = adapter;
      var refreshCalls = 0;
      dio.interceptors.add(
        RefreshTokenInterceptor(
          dio,
          excludedPaths: const {'/auth/refresh'},
          onRefreshToken: () async {
            refreshCalls++;
            return true;
          },
          onRefreshFailed: () {},
        ),
      );

      await expectLater(
        () => dio.get('/auth/refresh'),
        throwsA(isA<DioException>()),
      );
      expect(refreshCalls, 0);
    });

    test(
      'does not deadlock when onRefreshToken calls back into the same '
      'Dio instance and that call also 401s -- regression test for a '
      'reentrant onError call awaiting the very refresh it is part of',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
          ..httpClientAdapter = _AlwaysUnauthorizedAdapter();
        var refreshAttempts = 0;
        var loggedOut = false;

        dio.interceptors.add(
          RefreshTokenInterceptor(
            dio,
            excludedPaths: const {'/auth/refresh'},
            onRefreshToken: () async {
              refreshAttempts++;
              try {
                await dio.post('/auth/refresh');
                return true;
              } on DioException {
                return false;
              }
            },
            onRefreshFailed: () => loggedOut = true,
          ),
        );

        // Without the excludedPaths guard this hangs forever (a genuine
        // circular await, not slow I/O) -- the outer timeout is a safety
        // net for the test suite, not the thing being asserted on. A
        // TimeoutException here (the wrong exception type) is exactly
        // what a regression would look like.
        await expectLater(
          () => dio.get('/thing').timeout(const Duration(seconds: 5)),
          throwsA(isA<DioException>()),
        );

        expect(refreshAttempts, 1);
        expect(loggedOut, isTrue);
      },
    );
  });
}
