import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:feature_home/src/domain/entities/home_item.dart';
import 'package:feature_home/src/presentation/cubit/home_cubit.dart';
import 'package:feature_home/src/presentation/cubit/home_state.dart';
import 'package:feature_home/src/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

const _items = [
  // imageUrl deliberately null in every golden fixture -- Image.network
  // has no real network in a hermetic test, so it can't be part of a
  // deterministic pixel capture. The thumbnail's radius-token wiring is
  // verified structurally instead, in home_item_card_test.dart.
  HomeItem(id: '1', title: 'Sample item one', subtitle: 'First subtitle'),
  HomeItem(id: '2', title: 'Sample item two', subtitle: 'Second subtitle'),
];

Future<void> _pumpGolden(
  WidgetTester tester, {
  required ThemeData theme,
  required _MockHomeCubit cubit,
}) async {
  await tester.binding.setSurfaceSize(const Size(400, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider<HomeCubit>.value(
        value: cubit,
        child: const HomeView(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  late _MockHomeCubit cubit;

  setUp(() {
    cubit = _MockHomeCubit();
  });

  group('HomePage golden', () {
    // Proves _StaleBanner now uses AppSemanticColors.warning/.onWarning
    // instead of colorScheme.tertiaryContainer/.onTertiaryContainer.
    testWidgets('loaded, stale (light)', (tester) async {
      const state = HomeState.loaded(_items, isStale: true);
      when(() => cubit.state).thenReturn(state);
      whenListen(cubit, Stream.value(state), initialState: state);

      await _pumpGolden(tester, theme: AppTheme.light(), cubit: cubit);

      await expectLater(
        find.byType(HomeView),
        matchesGoldenFile('goldens/home_page_stale_light.png'),
      );
    });

    testWidgets('loaded, stale (dark)', (tester) async {
      const state = HomeState.loaded(_items, isStale: true);
      when(() => cubit.state).thenReturn(state);
      whenListen(cubit, Stream.value(state), initialState: state);

      await _pumpGolden(tester, theme: AppTheme.dark(), cubit: cubit);

      await expectLater(
        find.byType(HomeView),
        matchesGoldenFile('goldens/home_page_stale_dark.png'),
      );
    });

    // Proves the error message now uses colorScheme.error instead of the
    // default (untinted) text color.
    testWidgets('error (light)', (tester) async {
      const state = HomeState.error(NetworkFailure());
      when(() => cubit.state).thenReturn(state);
      whenListen(cubit, Stream.value(state), initialState: state);

      await _pumpGolden(tester, theme: AppTheme.light(), cubit: cubit);

      await expectLater(
        find.byType(HomeView),
        matchesGoldenFile('goldens/home_page_error_light.png'),
      );
    });

    testWidgets('error (dark)', (tester) async {
      const state = HomeState.error(NetworkFailure());
      when(() => cubit.state).thenReturn(state);
      whenListen(cubit, Stream.value(state), initialState: state);

      await _pumpGolden(tester, theme: AppTheme.dark(), cubit: cubit);

      await expectLater(
        find.byType(HomeView),
        matchesGoldenFile('goldens/home_page_error_dark.png'),
      );
    });
  });
}
