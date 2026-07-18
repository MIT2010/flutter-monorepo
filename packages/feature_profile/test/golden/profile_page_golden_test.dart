import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:feature_profile/src/presentation/cubit/profile_cubit.dart';
import 'package:feature_profile/src/presentation/cubit/profile_state.dart';
import 'package:feature_profile/src/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

Future<void> _pumpGolden(
  WidgetTester tester, {
  required ThemeData theme,
  required _MockProfileCubit cubit,
}) async {
  await tester.binding.setSurfaceSize(const Size(400, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider<ProfileCubit>.value(
        value: cubit,
        child: const ProfileView(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  late _MockProfileCubit cubit;

  setUp(() {
    cubit = _MockProfileCubit();
  });

  group('ProfilePage golden', () {
    // Proves the error message now uses colorScheme.error instead of the
    // default (untinted) text color -- the only real visual change on this
    // page; the loaded/saving form states are untouched by this work.
    testWidgets('error (light)', (tester) async {
      const state = ProfileState.error(NetworkFailure());
      when(() => cubit.state).thenReturn(state);
      whenListen(cubit, Stream.value(state), initialState: state);

      await _pumpGolden(tester, theme: AppTheme.light(), cubit: cubit);

      await expectLater(
        find.byType(ProfileView),
        matchesGoldenFile('goldens/profile_page_error_light.png'),
      );
    });

    testWidgets('error (dark)', (tester) async {
      const state = ProfileState.error(NetworkFailure());
      when(() => cubit.state).thenReturn(state);
      whenListen(cubit, Stream.value(state), initialState: state);

      await _pumpGolden(tester, theme: AppTheme.dark(), cubit: cubit);

      await expectLater(
        find.byType(ProfileView),
        matchesGoldenFile('goldens/profile_page_error_dark.png'),
      );
    });
  });
}
