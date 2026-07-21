import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Empty', type: AppSearchField)
Widget appSearchFieldEmptyUseCase(BuildContext context) {
  return const Center(child: SizedBox(width: 280, child: AppSearchField()));
}

@widgetbook.UseCase(name: 'With text', type: AppSearchField)
Widget appSearchFieldWithTextUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 280,
      child: AppSearchField(
        controller: TextEditingController(text: 'Sepatu lari'),
      ),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog.
@widgetbook.UseCase(name: 'Interactive', type: AppSearchField)
Widget appSearchFieldInteractiveUseCase(BuildContext context) {
  final hintText = context.knobs.string(
    label: 'Hint text',
    initialValue: 'Search',
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — focus recolor)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (clear-button fade)',
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
        child: AppSearchField(hintText: hintText, onChanged: (_) {}),
      ),
    ),
  );
}
