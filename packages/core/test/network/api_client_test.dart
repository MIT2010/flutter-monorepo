import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);
}

Dio _buildDio(Future<ResponseBody> Function(RequestOptions) handler) {
  return Dio(BaseOptions(baseUrl: 'https://api.test'))
    ..httpClientAdapter = _FakeAdapter(handler);
}

/// Dio's default transformer only auto-decodes the body as JSON when the
/// response carries a JSON content-type header, so fakes must set it too.
ResponseBody _jsonBody(Map<String, dynamic> json, int statusCode) {
  return ResponseBody.fromString(
    jsonEncode(json),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  group('ApiClient', () {
    test('get() returns Ok and parses a successful body', () async {
      final dio = _buildDio((options) async => _jsonBody({'id': 1}, 200));
      final client = ApiClient(dio);

      final result = await client.get<int>(
        '/thing',
        parser: (json) => (json as Map)['id'] as int,
      );

      expect(result.isOk, isTrue);
      expect((result as Ok<Failure, int>).value, 1);
    });

    test('post() returns Ok and parses a successful body', () async {
      final dio = _buildDio(
        (options) async => _jsonBody({'created': true}, 201),
      );
      final client = ApiClient(dio);

      final result = await client.post<bool>(
        '/thing',
        data: {'name': 'x'},
        parser: (json) => (json as Map)['created'] as bool,
      );

      expect(result.isOk, isTrue);
      expect((result as Ok<Failure, bool>).value, isTrue);
    });

    test('maps a 401 response to UnauthorizedFailure carrying the real '
        'server message, not the generic default', () async {
      final dio = _buildDio(
        (options) async =>
            _jsonBody({'message': 'Email atau kata sandi salah'}, 401),
      );
      final client = ApiClient(dio);

      final result = await client.get<Map>(
        '/thing',
        parser: (json) => json as Map,
      );

      expect(result.isErr, isTrue);
      final failure = (result as Err<Failure, Map>).failure;
      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'Email atau kata sandi salah');
    });

    test('falls back to the generic "Session expired" message when a 401 '
        'body carries none', () async {
      final dio = _buildDio((options) async => _jsonBody({}, 401));
      final client = ApiClient(dio);

      final result = await client.get<Map>(
        '/thing',
        parser: (json) => json as Map,
      );

      final failure = (result as Err<Failure, Map>).failure;
      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'Session expired');
    });

    test(
      'maps a 500 response to ServerFailure with the server message',
      () async {
        final dio = _buildDio(
          (options) async => _jsonBody({'message': 'db down'}, 500),
        );
        final client = ApiClient(dio);

        final result = await client.get<Map>(
          '/thing',
          parser: (json) => json as Map,
        );

        expect(result.isErr, isTrue);
        final failure = (result as Err<Failure, Map>).failure as ServerFailure;
        expect(failure.message, 'db down');
        expect(failure.statusCode, 500);
      },
    );

    test('falls back to a generic message when the body has none', () async {
      final dio = _buildDio((options) async => _jsonBody({}, 503));
      final client = ApiClient(dio);

      final result = await client.get<Map>(
        '/thing',
        parser: (json) => json as Map,
      );

      final failure = (result as Err<Failure, Map>).failure as ServerFailure;
      expect(failure.message, 'Server error');
    });

    test('maps a connection timeout to NetworkFailure', () async {
      final dio = _buildDio(
        (options) async => throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        ),
      );
      final client = ApiClient(dio);

      final result = await client.get<Map>(
        '/thing',
        parser: (json) => json as Map,
      );

      expect(result.isErr, isTrue);
      expect((result as Err<Failure, Map>).failure, isA<NetworkFailure>());
    });

    test('prefers a Failure already attached to the DioException', () async {
      final dio = _buildDio(
        (options) async => throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const NetworkFailure(),
        ),
      );
      final client = ApiClient(dio);

      final result = await client.get<Map>(
        '/thing',
        parser: (json) => json as Map,
      );

      expect((result as Err<Failure, Map>).failure, isA<NetworkFailure>());
    });

    group('parser exceptions (unrelated to DioException)', () {
      test('get() converts a parser exception to ParsingFailure instead of '
          'letting it escape uncaught', () async {
        final dio = _buildDio(
          (options) async => _jsonBody({'id': 'not-an-int'}, 200),
        );
        final client = ApiClient(dio);

        final result = await client.get<int>(
          '/thing',
          parser: (json) => (json as Map)['id'] as int,
        );

        expect(result.isErr, isTrue);
        expect((result as Err<Failure, int>).failure, isA<ParsingFailure>());
      });

      test('post() converts a parser exception to ParsingFailure', () async {
        final dio = _buildDio(
          (options) async => _jsonBody({'created': 'yes'}, 201),
        );
        final client = ApiClient(dio);

        final result = await client.post<bool>(
          '/thing',
          data: {'name': 'x'},
          parser: (json) => (json as Map)['created'] as bool,
        );

        expect((result as Err<Failure, bool>).failure, isA<ParsingFailure>());
      });

      test('put() converts a parser exception to ParsingFailure', () async {
        final dio = _buildDio(
          (options) async => _jsonBody({'updated': 'yes'}, 200),
        );
        final client = ApiClient(dio);

        final result = await client.put<bool>(
          '/thing',
          data: {'name': 'x'},
          parser: (json) => (json as Map)['updated'] as bool,
        );

        expect((result as Err<Failure, bool>).failure, isA<ParsingFailure>());
      });

      test('delete() converts a parser exception to ParsingFailure', () async {
        final dio = _buildDio(
          (options) async => _jsonBody({'deleted': 'yes'}, 200),
        );
        final client = ApiClient(dio);

        final result = await client.delete<bool>(
          '/thing',
          parser: (json) => (json as Map)['deleted'] as bool,
        );

        expect((result as Err<Failure, bool>).failure, isA<ParsingFailure>());
      });

      test(
        'multipart() converts a parser exception to ParsingFailure',
        () async {
          final dio = _buildDio(
            (options) async => _jsonBody({'uploaded': 'yes'}, 200),
          );
          final client = ApiClient(dio);

          final result = await client.multipart<bool>(
            '/thing',
            data: FormData(),
            parser: (json) => (json as Map)['uploaded'] as bool,
          );

          expect((result as Err<Failure, bool>).failure, isA<ParsingFailure>());
        },
      );
    });
  });
}
