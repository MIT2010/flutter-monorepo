import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

const _items = [
  AppDropdownItem(value: 'id', label: 'Indonesia'),
  AppDropdownItem(value: 'my', label: 'Malaysia'),
  AppDropdownItem(value: 'sg', label: 'Singapore'),
];

@widgetbook.UseCase(name: 'Unselected', type: AppDropdown)
Widget appDropdownUnselectedUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 280,
      child: AppDropdown<String>(
        label: 'Country',
        value: null,
        items: _items,
        hintText: 'Select a country',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Selected', type: AppDropdown)
Widget appDropdownSelectedUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 280,
      child: AppDropdown<String>(label: 'Country', value: 'my', items: _items),
    ),
  );
}

@widgetbook.UseCase(name: 'Error', type: AppDropdown)
Widget appDropdownErrorUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 280,
      child: AppDropdown<String>(
        label: 'Country',
        value: null,
        items: _items,
        errorText: 'Required',
      ),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog.
@widgetbook.UseCase(name: 'Interactive', type: AppDropdown)
Widget appDropdownInteractiveUseCase(BuildContext context) {
  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — focus border, selected option, chevron)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final radiusMultiplier = context.knobs.double.slider(
    label: 'Radius multiplier (option list radius.md)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return _InteractiveDropdown(
    primaryColor: primaryColor,
    radiusMultiplier: radiusMultiplier,
  );
}

class _InteractiveDropdown extends StatefulWidget {
  final Color primaryColor;
  final double radiusMultiplier;

  const _InteractiveDropdown({
    required this.primaryColor,
    required this.radiusMultiplier,
  });

  @override
  State<_InteractiveDropdown> createState() => _InteractiveDropdownState();
}

class _InteractiveDropdownState extends State<_InteractiveDropdown> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(
        primaryColor: widget.primaryColor,
        radiusMultiplier: widget.radiusMultiplier,
      ),
      child: Center(
        child: SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: _value,
            items: _items,
            hintText: 'Select a country',
            onChanged: (v) => setState(() => _value = v),
          ),
        ),
      ),
    );
  }
}
