import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppTabs golden', () {
    testWidgets('first tab selected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 60),
        child: const AppTabs(labels: ['Overview', 'Details', 'Reviews']),
      );
      await expectLater(
        find.byType(AppTabs),
        matchesGoldenFile('goldens/app_tabs_first_selected_light.png'),
      );
    });

    testWidgets('first tab selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 60),
        child: const AppTabs(labels: ['Overview', 'Details', 'Reviews']),
      );
      await expectLater(
        find.byType(AppTabs),
        matchesGoldenFile('goldens/app_tabs_first_selected_dark.png'),
      );
    });

    testWidgets('middle tab selected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 60),
        child: const AppTabs(
          labels: ['Overview', 'Details', 'Reviews'],
          initialIndex: 1,
        ),
      );
      await expectLater(
        find.byType(AppTabs),
        matchesGoldenFile('goldens/app_tabs_middle_selected_light.png'),
      );
    });

    testWidgets('middle tab selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 60),
        child: const AppTabs(
          labels: ['Overview', 'Details', 'Reviews'],
          initialIndex: 1,
        ),
      );
      await expectLater(
        find.byType(AppTabs),
        matchesGoldenFile('goldens/app_tabs_middle_selected_dark.png'),
      );
    });
  });
}
