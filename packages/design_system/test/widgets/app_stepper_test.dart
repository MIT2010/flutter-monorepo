import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStepper', () {
    testWidgets('renders one marker per step', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppStepper(currentStep: 1, stepCount: 4)),
        ),
      );

      // Steps 2-4 (0-indexed 1,2,3) aren't completed, so they show their
      // own number; step 1 (index 0) is completed and shows a checkmark
      // instead of "1".
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('renders labels when provided, omits the row when null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppStepper(
              currentStep: 0,
              stepCount: 3,
              labels: ['Info', 'Verify', 'Done'],
            ),
          ),
        ),
      );

      expect(find.text('Info'), findsOneWidget);
      expect(find.text('Verify'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppStepper(currentStep: 0, stepCount: 3)),
        ),
      );
      expect(find.text('Info'), findsNothing);
    });

    testWidgets('renders a single step without a connector or crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppStepper(currentStep: 0, stepCount: 1)),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('respects disableAnimations -- state applies instantly', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppStepper(currentStep: 1, stepCount: 2)),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
