import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:authentication/authentication.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:feature_home/feature_home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:mobile/src/di/injection.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared/shared.dart' hide configureDependencies;

/// `feature_home`'s DI graph opens a real Hive box during
/// `configureDependencies()` (same `@preResolve` `widget_test.dart`
/// already works around) -- needs `getApplicationDocumentsDirectory()`,
/// which has no handler under plain `flutter_test`.
class _FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async =>
      Directory.systemTemp.createTempSync('mobile_test_').path;
}

/// Pre-opening an in-memory box under the same name short-circuits
/// `RegisterModule.homeItemsBox`'s later real-file-backed open -- see
/// `widget_test.dart` for why the real, file-backed box also hangs under
/// `flutter_test`.
Future<void> _preOpenInMemoryHomeItemsBox() async {
  await Hive.openBox<HomeItemModel>('home_items', bytes: Uint8List(0));
}

/// Serves both `/auth/refresh` (always a fresh token pair) and any other
/// path (401 once, then 200 once retried) through the same fake backend
/// -- proves a real round trip through the app's actual interceptor
/// chain, not a hand-assembled one built just for this test.
class _FakeBackendAdapter implements HttpClientAdapter {
  int thingCallCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path == '/auth/refresh') {
      return ResponseBody.fromString(
        jsonEncode({
          'accessToken': 'new-access',
          'refreshToken': 'new-refresh',
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    thingCallCount++;
    final alreadyRetried = options.extra['refreshRetried'] == true;
    if (!alreadyRetried) {
      return ResponseBody.fromString('{}', 401);
    }
    return ResponseBody.fromString('{"ok":true}', 200);
  }
}

void main() {
  // AuthCubit's constructor reads the cached session through the real
  // SecureTokenStorage -> FlutterSecureStorage, not a mock -- this is
  // exactly what proves the full DI graph below is the genuine app
  // composition, not a stand-in. FlutterSecureStorage.setMockInitialValues
  // is that package's own supported test double for exactly this
  // situation (no platform channel under plain `flutter_test`); seeded
  // with a real session so AuthRepositoryImpl.refreshToken() has an
  // actual refresh token to send.
  setUpAll(() => PathProviderPlatform.instance = _FakePathProviderPlatform());
  setUp(
    () => FlutterSecureStorage.setMockInitialValues({
      'access_token': 'old-access',
      'refresh_token': 'old-refresh',
      'cached_user': jsonEncode({
        'id': '1',
        'email': 'a@example.com',
        'role': 'user',
      }),
    }),
  );
  tearDown(() => getIt.reset());

  // One test, not two -- Hive's TypeAdapter registry is process-global,
  // not reset by getIt.reset() between tests, so a second
  // configureDependencies() call in the same process throws ("There is
  // already a TypeAdapter for typeId 0") the moment it re-runs
  // feature_home's RegisterModule.homeItemsBox. Both assertions genuinely
  // belong to the same DI-resolution story anyway.
  test(
    'configureDependencies resolves Dio/ApiClient/AuthCubit without '
    'hanging -- regression test for a circular DI dependency (Dio needs '
    'TokenRefresher needs AuthCubit needs AuthRepository needs '
    'AuthRemoteDataSource needs ApiClient needs Dio) that would otherwise '
    'deadlock GetIt resolving Dio for the very first time -- and, once '
    'resolved, the real interceptor chain actually refreshes through '
    'AuthCubit.refresh and retries the original request, proving '
    'RefreshTokenInterceptor/AuthInterceptor/TokenRefresher are genuinely '
    'wired into the app\'s own Dio instance, not just present as unused '
    'classes. A TimeoutException on the first await (not a completed '
    'Future) is exactly what a deadlock regression would look like.',
    () async {
      await _preOpenInMemoryHomeItemsBox();
      await configureDependencies(
        env: Env.current,
      ).timeout(const Duration(seconds: 5));

      expect(getIt<ApiClient>(), isA<ApiClient>());
      expect(getIt<AuthCubit>(), isA<AuthCubit>());

      // Lets AuthCubit's cached-session restoration finish before the
      // interceptor chain runs, so `refresh()` exercises its
      // AuthAuthenticated branch (emit refreshing -> authenticated), not
      // just the not-yet-restored fallback -- both would still resolve
      // correctly, but this is the realistic ordering.
      await pumpEventQueue();

      final dio = getIt<Dio>();
      final adapter = _FakeBackendAdapter();
      dio.httpClientAdapter = adapter;

      final response = await dio
          .get('/thing')
          .timeout(const Duration(seconds: 5));

      expect(response.statusCode, 200);
      expect(adapter.thingCallCount, 2);
      expect(getIt<AuthCubit>().state, isA<AuthAuthenticated>());
    },
  );
}
