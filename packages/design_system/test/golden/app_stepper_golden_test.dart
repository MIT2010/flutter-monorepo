import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppStepper golden', () {
    testWidgets('middle step current, with labels (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(360, 80),
        child: const SizedBox(
          width: 340,
          child: AppStepper(
            currentStep: 1,
            stepCount: 4,
            labels: ['Info', 'Verify', 'Confirm', 'Done'],
          ),
        ),
      );

      await expectLater(
        find.byType(AppStepper),
        matchesGoldenFile('goldens/app_stepper_middle_light.png'),
      );
    });

    testWidgets('middle step current, with labels (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(360, 80),
        child: const SizedBox(
          width: 340,
          child: AppStepper(
            currentStep: 1,
            stepCount: 4,
            labels: ['Info', 'Verify', 'Confirm', 'Done'],
          ),
        ),
      );

      await expectLater(
        find.byType(AppStepper),
        matchesGoldenFile('goldens/app_stepper_middle_dark.png'),
      );
    });

    testWidgets('final step completed, no labels (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(360, 50),
        child: const SizedBox(
          width: 340,
          child: AppStepper(currentStep: 3, stepCount: 4),
        ),
      );

      await expectLater(
        find.byType(AppStepper),
        matchesGoldenFile('goldens/app_stepper_final_light.png'),
      );
    });

    testWidgets('final step completed, no labels (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(360, 50),
        child: const SizedBox(
          width: 340,
          child: AppStepper(currentStep: 3, stepCount: 4),
        ),
      );

      await expectLater(
        find.byType(AppStepper),
        matchesGoldenFile('goldens/app_stepper_final_dark.png'),
      );
    });
  });
}
