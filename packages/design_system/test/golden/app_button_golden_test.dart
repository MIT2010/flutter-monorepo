import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppButton golden', () {
    testWidgets('default (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        child: AppButton(label: 'Login', onPressed: () {}),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_default_light.png'),
      );
    });

    testWidgets('default (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        child: AppButton(label: 'Login', onPressed: () {}),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_default_dark.png'),
      );
    });

    testWidgets('loading (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        child: AppButton(label: 'Login', onPressed: () {}, loading: true),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_loading_light.png'),
      );
    });

    testWidgets('loading (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        child: AppButton(label: 'Login', onPressed: () {}, loading: true),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_loading_dark.png'),
      );
    });

    testWidgets('with icon (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        child: AppButton(
          label: 'Continue',
          onPressed: () {},
          icon: Icons.arrow_forward,
        ),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_icon_light.png'),
      );
    });

    testWidgets('with icon (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        child: AppButton(
          label: 'Continue',
          onPressed: () {},
          icon: Icons.arrow_forward,
        ),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_icon_dark.png'),
      );
    });

    testWidgets('disabled (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        child: const AppButton(label: 'Login', onPressed: null),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_disabled_light.png'),
      );
    });

    testWidgets('disabled (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        child: const AppButton(label: 'Login', onPressed: null),
      );
      await expectLater(
        find.byType(AppButton),
        matchesGoldenFile('goldens/app_button_disabled_dark.png'),
      );
    });
  });
}
