import 'package:authentication/authentication.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  const user = User(id: '1', email: 'a@example.com', role: 'admin');

  setUp(() {
    repository = _MockAuthRepository();
  });

  group('AuthCubit — restores the cached session at construction', () {
    test('emits authenticated(user) when a user is cached', () async {
      when(() => repository.getCachedUser()).thenAnswer((_) async => user);

      final cubit = AuthCubit(repository);
      await pumpEventQueue();

      expect(cubit.state, AuthState.authenticated(user));
    });

    test('emits unauthenticated() when nothing is cached', () async {
      when(() => repository.getCachedUser()).thenAnswer((_) async => null);

      final cubit = AuthCubit(repository);
      await pumpEventQueue();

      expect(cubit.state, const AuthState.unauthenticated());
    });
  });

  test('setAuthenticated makes a fresh login visible immediately, without '
      'waiting on the cache read', () async {
    when(() => repository.getCachedUser()).thenAnswer((_) async => null);
    final cubit = AuthCubit(repository);
    await pumpEventQueue();
    expect(cubit.state, const AuthState.unauthenticated());

    cubit.setAuthenticated(user);

    expect(cubit.state, AuthState.authenticated(user));
  });

  test('logout clears the repository and emits unauthenticated()', () async {
    when(() => repository.getCachedUser()).thenAnswer((_) async => user);
    when(() => repository.logout()).thenAnswer((_) async => const Ok(null));
    final cubit = AuthCubit(repository);
    await pumpEventQueue();
    expect(cubit.state, AuthState.authenticated(user));

    await cubit.logout();

    expect(cubit.state, const AuthState.unauthenticated());
    verify(() => repository.logout()).called(1);
  });

  group('AuthCubit implements TokenRefresher — RefreshTokenInterceptor\'s '
      'contract', () {
    test('refresh() on a successful call emits refreshing(user) then restores '
        'authenticated(user), in that exact order', () async {
      when(() => repository.getCachedUser()).thenAnswer((_) async => user);
      when(() => repository.refreshToken()).thenAnswer((_) async => true);
      final cubit = AuthCubit(repository);
      await pumpEventQueue();

      final states = <AuthState>[];
      final subscription = cubit.stream.listen(states.add);

      final refreshed = await cubit.refresh();
      await pumpEventQueue();
      await subscription.cancel();

      expect(refreshed, isTrue);
      expect(states, [
        AuthState.refreshing(user),
        AuthState.authenticated(user),
      ]);
    });

    test('refresh() on a failed call leaves state at refreshing(user) -- only '
        'forceLogout (RefreshTokenInterceptor\'s separate onRefreshFailed '
        'call) ever moves this to unauthenticated', () async {
      when(() => repository.getCachedUser()).thenAnswer((_) async => user);
      when(() => repository.refreshToken()).thenAnswer((_) async => false);
      final cubit = AuthCubit(repository);
      await pumpEventQueue();

      final refreshed = await cubit.refresh();

      expect(refreshed, isFalse);
      expect(cubit.state, AuthState.refreshing(user));
    });

    test('refresh() delegates straight to the repository when not currently '
        'authenticated, without emitting refreshing() -- there is no live '
        'session to show a "refreshing" view of', () async {
      when(() => repository.getCachedUser()).thenAnswer((_) async => null);
      when(() => repository.refreshToken()).thenAnswer((_) async => false);
      final cubit = AuthCubit(repository);
      await pumpEventQueue();

      final states = <AuthState>[];
      final subscription = cubit.stream.listen(states.add);

      final refreshed = await cubit.refresh();
      await subscription.cancel();

      expect(refreshed, isFalse);
      expect(states, isEmpty);
    });

    test('forceLogout() is exactly logout() under another name', () async {
      when(() => repository.getCachedUser()).thenAnswer((_) async => user);
      when(() => repository.logout()).thenAnswer((_) async => const Ok(null));
      final cubit = AuthCubit(repository);
      await pumpEventQueue();

      await cubit.forceLogout();

      expect(cubit.state, const AuthState.unauthenticated());
      verify(() => repository.logout()).called(1);
    });
  });
}
