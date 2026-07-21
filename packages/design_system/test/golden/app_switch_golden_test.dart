import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppSwitch golden', () {
    testWidgets('off (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 44),
        child: AppSwitch(value: false, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_off_light.png'),
      );
    });

    testWidgets('off (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 44),
        child: AppSwitch(value: false, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_off_dark.png'),
      );
    });

    testWidgets('on (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 44),
        child: AppSwitch(value: true, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_on_light.png'),
      );
    });

    testWidgets('on (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 44),
        child: AppSwitch(value: true, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_on_dark.png'),
      );
    });

    testWidgets('disabled, off (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 44),
        child: const AppSwitch(value: false, onChanged: null),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_disabled_off_light.png'),
      );
    });

    testWidgets('disabled, off (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 44),
        child: const AppSwitch(value: false, onChanged: null),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_disabled_off_dark.png'),
      );
    });

    testWidgets('disabled, on (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 44),
        child: const AppSwitch(value: true, onChanged: null),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_disabled_on_light.png'),
      );
    });

    testWidgets('disabled, on (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 44),
        child: const AppSwitch(value: true, onChanged: null),
      );
      await expectLater(
        find.byType(AppSwitch),
        matchesGoldenFile('goldens/app_switch_disabled_on_dark.png'),
      );
    });
  });
}
