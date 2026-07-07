import 'package:authentication/authentication.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late _MockLoginUseCase loginUseCase;

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  setUp(() {
    loginUseCase = _MockLoginUseCase();
  });

  const user = User(id: '1', email: 'a@example.com', role: 'admin');

  blocTest<LoginCubit, LoginState>(
    'emits [loading, success] when the use case succeeds',
    build: () {
      when(() => loginUseCase(any())).thenAnswer((_) async => const Ok(user));
      return LoginCubit(loginUseCase);
    },
    act: (cubit) => cubit.submit(email: 'a@example.com', password: 'secret'),
    expect: () => [const LoginState.loading(), LoginState.success(user)],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [loading, failure] when the use case fails',
    build: () {
      when(
        () => loginUseCase(any()),
      ).thenAnswer((_) async => const Err(UnauthorizedFailure()));
      return LoginCubit(loginUseCase);
    },
    act: (cubit) => cubit.submit(email: 'a@example.com', password: 'wrong'),
    expect: () => [
      const LoginState.loading(),
      const LoginState.failure(UnauthorizedFailure()),
    ],
  );
}
