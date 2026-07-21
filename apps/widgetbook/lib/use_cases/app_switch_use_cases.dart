import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Off', type: AppSwitch)
Widget appSwitchOffUseCase(BuildContext context) {
  return Center(child: AppSwitch(value: false, onChanged: (_) {}));
}

@widgetbook.UseCase(name: 'On', type: AppSwitch)
Widget appSwitchOnUseCase(BuildContext context) {
  return Center(child: AppSwitch(value: true, onChanged: (_) {}));
}

@widgetbook.UseCase(name: 'Disabled', type: AppSwitch)
Widget appSwitchDisabledUseCase(BuildContext context) {
  return const Center(child: AppSwitch(value: true, onChanged: null));
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog.
@widgetbook.UseCase(name: 'Interactive', type: AppSwitch)
Widget appSwitchInteractiveUseCase(BuildContext context) {
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — on-track)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (thumb slide)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return _InteractiveSwitch(
    disabled: disabled,
    primaryColor: primaryColor,
    motionSpeedMultiplier: motionSpeedMultiplier,
  );
}

class _InteractiveSwitch extends StatefulWidget {
  final bool disabled;
  final Color primaryColor;
  final double motionSpeedMultiplier;

  const _InteractiveSwitch({
    required this.disabled,
    required this.primaryColor,
    required this.motionSpeedMultiplier,
  });

  @override
  State<_InteractiveSwitch> createState() => _InteractiveSwitchState();
}

class _InteractiveSwitchState extends State<_InteractiveSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(
        primaryColor: widget.primaryColor,
        motionSpeedMultiplier: widget.motionSpeedMultiplier,
      ),
      child: Center(
        child: AppSwitch(
          value: _value,
          onChanged: widget.disabled ? null : (v) => setState(() => _value = v),
        ),
      ),
    );
  }
}
