import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Default', type: AppTabs)
Widget appTabsDefaultUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 320,
      child: AppTabs(labels: ['Overview', 'Details', 'Reviews']),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog.
@widgetbook.UseCase(name: 'Interactive', type: AppTabs)
Widget appTabsInteractiveUseCase(BuildContext context) {
  final initialIndex = context.knobs.int.slider(
    label: 'Initial tab',
    initialValue: 0,
    min: 0,
    max: 2,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — underline/selected label)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (underline slide)',
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
        width: 320,
        child: AppTabs(
          labels: const ['Overview', 'Details', 'Reviews'],
          initialIndex: initialIndex,
          onChanged: (_) {},
        ),
      ),
    ),
  );
}
