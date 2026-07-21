import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Unselected', type: AppTag)
Widget appTagUnselectedUseCase(BuildContext context) {
  return const Center(child: AppTag(label: 'Filter'));
}

@widgetbook.UseCase(name: 'Selected', type: AppTag)
Widget appTagSelectedUseCase(BuildContext context) {
  return const Center(child: AppTag(label: 'Active', selected: true));
}

@widgetbook.UseCase(name: 'Removable', type: AppTag)
Widget appTagRemovableUseCase(BuildContext context) {
  return Center(
    child: AppTag(label: 'Removable', onRemove: () {}),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio.**
/// `context.knobs.*` controls apply only to this one catalog entry and
/// reset when you navigate away; `apps/widgetbook/lib/addons/
/// theme_studio_addon.dart`'s `ThemeStudioAddon` is the complementary
/// tool for a change meant to apply to the *whole* catalog at once. Both
/// read the same underlying `AppTheme.light(...)` override parameters —
/// this use-case doesn't invent a second theming mechanism, it just
/// drives the existing one from a scope-of-one instead of a global addon.
@widgetbook.UseCase(name: 'Interactive', type: AppTag)
Widget appTagInteractiveUseCase(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Filter');
  final selected = context.knobs.boolean(
    label: 'Selected',
    initialValue: false,
  );
  final removable = context.knobs.boolean(
    label: 'Removable',
    initialValue: false,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — selected fill/border)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final radiusMultiplier = context.knobs.double.slider(
    label: 'Radius multiplier',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (selection/removal transitions)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return Theme(
    data: AppTheme.light(
      primaryColor: primaryColor,
      radiusMultiplier: radiusMultiplier,
      motionSpeedMultiplier: motionSpeedMultiplier,
    ),
    child: Center(
      child: AppTag(
        label: label,
        selected: selected,
        onTap: () {},
        onRemove: removable ? () {} : null,
      ),
    ),
  );
}
