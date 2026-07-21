import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppRadio golden', () {
    testWidgets('unselected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: AppRadio<int>(value: 1, groupValue: 0, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_unselected_light.png'),
      );
    });

    testWidgets('unselected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: AppRadio<int>(value: 1, groupValue: 0, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_unselected_dark.png'),
      );
    });

    testWidgets('selected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_selected_light.png'),
      );
    });

    testWidgets('selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_selected_dark.png'),
      );
    });

    testWidgets('disabled, unselected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: const AppRadio<int>(value: 1, groupValue: 0, onChanged: null),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_disabled_unselected_light.png'),
      );
    });

    testWidgets('disabled, unselected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: const AppRadio<int>(value: 1, groupValue: 0, onChanged: null),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_disabled_unselected_dark.png'),
      );
    });

    testWidgets('disabled, selected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(60, 60),
        child: const AppRadio<int>(value: 1, groupValue: 1, onChanged: null),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_disabled_selected_light.png'),
      );
    });

    testWidgets('disabled, selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(60, 60),
        child: const AppRadio<int>(value: 1, groupValue: 1, onChanged: null),
      );
      await expectLater(
        find.byType(AppRadio<int>),
        matchesGoldenFile('goldens/app_radio_disabled_selected_dark.png'),
      );
    });
  });
}
