import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Unselected', type: AppRadio)
Widget appRadioUnselectedUseCase(BuildContext context) {
  return Center(
    child: AppRadio<int>(value: 1, groupValue: 0, onChanged: (_) {}),
  );
}

@widgetbook.UseCase(name: 'Selected', type: AppRadio)
Widget appRadioSelectedUseCase(BuildContext context) {
  return Center(
    child: AppRadio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: AppRadio)
Widget appRadioDisabledUseCase(BuildContext context) {
  return const Center(
    child: AppRadio<int>(value: 1, groupValue: 1, onChanged: null),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. A real 3-way group (not just a
/// single toggling instance) so "mutually exclusive" is actually visible,
/// not just asserted.
@widgetbook.UseCase(name: 'Interactive (group of 3)', type: AppRadio)
Widget appRadioInteractiveUseCase(BuildContext context) {
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — selected dot/ring)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (dot fade/scale)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return _InteractiveRadioGroup(
    disabled: disabled,
    primaryColor: primaryColor,
    motionSpeedMultiplier: motionSpeedMultiplier,
  );
}

class _InteractiveRadioGroup extends StatefulWidget {
  final bool disabled;
  final Color primaryColor;
  final double motionSpeedMultiplier;

  const _InteractiveRadioGroup({
    required this.disabled,
    required this.primaryColor,
    required this.motionSpeedMultiplier,
  });

  @override
  State<_InteractiveRadioGroup> createState() => _InteractiveRadioGroupState();
}

class _InteractiveRadioGroupState extends State<_InteractiveRadioGroup> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(
        primaryColor: widget.primaryColor,
        motionSpeedMultiplier: widget.motionSpeedMultiplier,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              AppRadio<int>(
                value: i,
                groupValue: _selected,
                onChanged: widget.disabled
                    ? null
                    : (v) => setState(() => _selected = v!),
              ),
          ],
        ),
      ),
    );
  }
}
