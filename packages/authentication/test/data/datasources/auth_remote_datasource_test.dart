import 'package:authentication/authentication.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient client;
  late AuthRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    client = _MockApiClient();
    dataSource = AuthRemoteDataSource(client);
  });

  test(
    'login posts to /auth/login with the given credentials and parses the body',
    () async {
      const model = UserModel(
        id: '1',
        email: 'a@example.com',
        role: 'admin',
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
      );

      when(
        () => client.post<UserModel>(
          '/auth/login',
          data: any(named: 'data'),
          parser: any(named: 'parser'),
        ),
      ).thenAnswer((invocation) async {
        final parser =
            invocation.namedArguments[#parser] as UserModel Function(dynamic);
        return Ok(parser(model.toJson()));
      });

      final result = await dataSource.login('a@example.com', 'secret');

      expect(result.isOk, isTrue);
      expect((result as Ok<Failure, UserModel>).value, model);

      final captured = verify(
        () => client.post<UserModel>(
          '/auth/login',
          data: captureAny(named: 'data'),
          parser: any(named: 'parser'),
        ),
      ).captured.single;
      expect(captured, {'email': 'a@example.com', 'password': 'secret'});
    },
  );

  test('refresh posts to /auth/refresh with the given refresh token and '
      'parses the new token pair', () async {
    const pair = TokenPairModel(
      accessToken: 'access-2',
      refreshToken: 'refresh-2',
    );

    when(
      () => client.post<TokenPairModel>(
        '/auth/refresh',
        data: any(named: 'data'),
        parser: any(named: 'parser'),
      ),
    ).thenAnswer((invocation) async {
      final parser =
          invocation.namedArguments[#parser]
              as TokenPairModel Function(dynamic);
      return Ok(parser(pair.toJson()));
    });

    final result = await dataSource.refresh('refresh-1');

    expect(result.isOk, isTrue);
    expect((result as Ok<Failure, TokenPairModel>).value, pair);

    final captured = verify(
      () => client.post<TokenPairModel>(
        '/auth/refresh',
        data: captureAny(named: 'data'),
        parser: any(named: 'parser'),
      ),
    ).captured.single;
    expect(captured, {'refreshToken': 'refresh-1'});
  });
}
