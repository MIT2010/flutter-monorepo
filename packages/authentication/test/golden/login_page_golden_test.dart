import 'package:authentication/src/presentation/cubit/login_cubit.dart';
import 'package:authentication/src/presentation/cubit/login_state.dart';
import 'package:authentication/src/presentation/pages/login_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

/// `find.byType(LoginView)` (not `MaterialApp`) captures the SnackBar too --
/// Flutter attaches it within the nearest `Scaffold`'s bounds, which
/// `LoginView.build()` returns directly.
Future<void> _pumpGolden(
  WidgetTester tester, {
  required ThemeData theme,
  required _MockLoginCubit cubit,
}) async {
  await tester.binding.setSurfaceSize(const Size(400, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider<LoginCubit>.value(
        value: cubit,
        child: const LoginView(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  late _MockLoginCubit cubit;

  setUp(() {
    cubit = _MockLoginCubit();
    when(() => cubit.state).thenReturn(const LoginState.initial());
  });

  group('LoginPage golden', () {
    testWidgets('default (light)', (tester) async {
      whenListen(
        cubit,
        const Stream<LoginState>.empty(),
        initialState: const LoginState.initial(),
      );

      await _pumpGolden(tester, theme: AppTheme.light(), cubit: cubit);

      await expectLater(
        find.byType(LoginView),
        matchesGoldenFile('goldens/login_page_default_light.png'),
      );
    });

    testWidgets('default (dark)', (tester) async {
      whenListen(
        cubit,
        const Stream<LoginState>.empty(),
        initialState: const LoginState.initial(),
      );

      await _pumpGolden(tester, theme: AppTheme.dark(), cubit: cubit);

      await expectLater(
        find.byType(LoginView),
        matchesGoldenFile('goldens/login_page_default_dark.png'),
      );
    });

    // Proves the SnackBar now tints with colorScheme.error/.onError instead
    // of the default (untinted) SnackBar theme.
    testWidgets('failure snackbar (light)', (tester) async {
      whenListen(
        cubit,
        Stream.fromIterable([const LoginState.failure(UnauthorizedFailure())]),
        initialState: const LoginState.initial(),
      );

      await _pumpGolden(tester, theme: AppTheme.light(), cubit: cubit);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(LoginView),
        matchesGoldenFile('goldens/login_page_failure_light.png'),
      );
    });

    testWidgets('failure snackbar (dark)', (tester) async {
      whenListen(
        cubit,
        Stream.fromIterable([const LoginState.failure(UnauthorizedFailure())]),
        initialState: const LoginState.initial(),
      );

      await _pumpGolden(tester, theme: AppTheme.dark(), cubit: cubit);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(LoginView),
        matchesGoldenFile('goldens/login_page_failure_dark.png'),
      );
    });
  });
}
