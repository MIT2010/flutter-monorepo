import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppCheckbox golden', () {
    testWidgets('unchecked (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: AppCheckbox(value: false, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_unchecked_light.png'),
      );
    });

    testWidgets('unchecked (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: AppCheckbox(value: false, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_unchecked_dark.png'),
      );
    });

    testWidgets('checked (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: AppCheckbox(value: true, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_checked_light.png'),
      );
    });

    testWidgets('checked (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: AppCheckbox(value: true, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_checked_dark.png'),
      );
    });

    testWidgets('indeterminate (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: AppCheckbox(value: null, onChanged: (_) {}, tristate: true),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_indeterminate_light.png'),
      );
    });

    testWidgets('indeterminate (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: AppCheckbox(value: null, onChanged: (_) {}, tristate: true),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_indeterminate_dark.png'),
      );
    });

    testWidgets('disabled, unchecked (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: const AppCheckbox(value: false, onChanged: null),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_disabled_unchecked_light.png'),
      );
    });

    testWidgets('disabled, unchecked (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: const AppCheckbox(value: false, onChanged: null),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_disabled_unchecked_dark.png'),
      );
    });

    testWidgets('disabled, checked (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: const AppCheckbox(value: true, onChanged: null),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_disabled_checked_light.png'),
      );
    });

    testWidgets('disabled, checked (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: const AppCheckbox(value: true, onChanged: null),
      );
      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_disabled_checked_dark.png'),
      );
    });
  });
}
