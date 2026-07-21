import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Unchecked', type: AppCheckbox)
Widget appCheckboxUncheckedUseCase(BuildContext context) {
  return Center(child: AppCheckbox(value: false, onChanged: (_) {}));
}

@widgetbook.UseCase(name: 'Checked', type: AppCheckbox)
Widget appCheckboxCheckedUseCase(BuildContext context) {
  return Center(child: AppCheckbox(value: true, onChanged: (_) {}));
}

@widgetbook.UseCase(name: 'Indeterminate', type: AppCheckbox)
Widget appCheckboxIndeterminateUseCase(BuildContext context) {
  return Center(
    child: AppCheckbox(value: null, tristate: true, onChanged: (_) {}),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: AppCheckbox)
Widget appCheckboxDisabledUseCase(BuildContext context) {
  return const Center(child: AppCheckbox(value: true, onChanged: null));
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as `app_tag_use_cases.dart`/`app_calendar_use_cases.dart`: knobs
/// here apply only to this one catalog entry, while
/// `apps/widgetbook/lib/addons/theme_studio_addon.dart`'s `ThemeStudioAddon`
/// remains the tool for a whole-catalog retheme.
@widgetbook.UseCase(name: 'Interactive', type: AppCheckbox)
Widget appCheckboxInteractiveUseCase(BuildContext context) {
  final tristate = context.knobs.boolean(
    label: 'Tristate (allow indeterminate)',
    initialValue: true,
  );
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — checked fill)',
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
    label: 'Motion speed multiplier (glyph fade/scale)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return _InteractiveCheckbox(
    tristate: tristate,
    disabled: disabled,
    primaryColor: primaryColor,
    radiusMultiplier: radiusMultiplier,
    motionSpeedMultiplier: motionSpeedMultiplier,
  );
}

class _InteractiveCheckbox extends StatefulWidget {
  final bool tristate;
  final bool disabled;
  final Color primaryColor;
  final double radiusMultiplier;
  final double motionSpeedMultiplier;

  const _InteractiveCheckbox({
    required this.tristate,
    required this.disabled,
    required this.primaryColor,
    required this.radiusMultiplier,
    required this.motionSpeedMultiplier,
  });

  @override
  State<_InteractiveCheckbox> createState() => _InteractiveCheckboxState();
}

class _InteractiveCheckboxState extends State<_InteractiveCheckbox> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(
        primaryColor: widget.primaryColor,
        radiusMultiplier: widget.radiusMultiplier,
        motionSpeedMultiplier: widget.motionSpeedMultiplier,
      ),
      child: Center(
        child: AppCheckbox(
          value: _value,
          tristate: widget.tristate,
          onChanged: widget.disabled ? null : (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
