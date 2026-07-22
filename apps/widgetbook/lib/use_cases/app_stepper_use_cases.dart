import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Middle step, with labels', type: AppStepper)
Widget appStepperMiddleUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 340,
      child: AppStepper(
        currentStep: 1,
        stepCount: 4,
        labels: ['Info', 'Verify', 'Confirm', 'Done'],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Marker-only, no labels', type: AppStepper)
Widget appStepperMarkerOnlyUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 340,
      child: AppStepper(currentStep: 2, stepCount: 4),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: AppStepper)
Widget appStepperInteractiveUseCase(BuildContext context) {
  final stepCount = context.knobs.int.slider(
    label: 'Step count',
    initialValue: 4,
    min: 2,
    max: 6,
  );
  final currentStep = context.knobs.int.slider(
    label: 'Current step (0-indexed)',
    initialValue: 1,
    min: 0,
    max: stepCount - 1,
  );
  final showLabels = context.knobs.boolean(
    label: 'Show labels',
    initialValue: true,
  );

  const allLabels = ['Info', 'Verify', 'Confirm', 'Payment', 'Review', 'Done'];

  return Center(
    child: SizedBox(
      width: 380,
      child: AppStepper(
        currentStep: currentStep,
        stepCount: stepCount,
        labels: showLabels ? allLabels.take(stepCount).toList() : null,
      ),
    ),
  );
}
