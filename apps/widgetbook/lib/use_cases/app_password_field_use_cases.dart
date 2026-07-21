import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Default', type: AppPasswordField)
Widget appPasswordFieldDefaultUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(width: 280, child: AppPasswordField(label: 'Password')),
  );
}

@widgetbook.UseCase(name: 'Error', type: AppPasswordField)
Widget appPasswordFieldErrorUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 280,
      child: AppPasswordField(
        label: 'Password',
        errorText: 'Minimum 8 karakter',
      ),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog.
@widgetbook.UseCase(name: 'Interactive', type: AppPasswordField)
Widget appPasswordFieldInteractiveUseCase(BuildContext context) {
  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — reveal-toggle tap flash)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (tap-flash settle)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return Theme(
    data: AppTheme.light(
      primaryColor: primaryColor,
      motionSpeedMultiplier: motionSpeedMultiplier,
    ),
    child: Center(
      child: SizedBox(
        width: 280,
        child: AppPasswordField(label: 'Password', onChanged: (_) {}),
      ),
    ),
  );
}
