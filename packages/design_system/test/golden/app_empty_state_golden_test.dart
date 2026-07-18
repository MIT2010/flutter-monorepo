import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppEmptyState golden', () {
    testWidgets('with action (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 260),
        child: AppEmptyState(
          icon: Icons.inbox,
          message: 'Belum ada data',
          actionLabel: 'Muat ulang',
          onAction: () {},
        ),
      );
      await expectLater(
        find.byType(AppEmptyState),
        matchesGoldenFile('goldens/app_empty_state_action_light.png'),
      );
    });

    testWidgets('with action (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 260),
        child: AppEmptyState(
          icon: Icons.inbox,
          message: 'Belum ada data',
          actionLabel: 'Muat ulang',
          onAction: () {},
        ),
      );
      await expectLater(
        find.byType(AppEmptyState),
        matchesGoldenFile('goldens/app_empty_state_action_dark.png'),
      );
    });

    testWidgets('without action (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 200),
        child: const AppEmptyState(
          icon: Icons.search_off,
          message: 'Page not found',
        ),
      );
      await expectLater(
        find.byType(AppEmptyState),
        matchesGoldenFile('goldens/app_empty_state_no_action_light.png'),
      );
    });

    testWidgets('without action (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 200),
        child: const AppEmptyState(
          icon: Icons.search_off,
          message: 'Page not found',
        ),
      );
      await expectLater(
        find.byType(AppEmptyState),
        matchesGoldenFile('goldens/app_empty_state_no_action_dark.png'),
      );
    });
  });
}
