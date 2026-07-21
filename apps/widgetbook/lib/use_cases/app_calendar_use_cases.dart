import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Default', type: AppCalendar)
Widget appCalendarDefaultUseCase(BuildContext context) {
  return Center(child: AppCalendar(initialMonth: DateTime(2026, 7)));
}

@widgetbook.UseCase(name: 'With a selected date', type: AppCalendar)
Widget appCalendarSelectedUseCase(BuildContext context) {
  return Center(
    child: AppCalendar(
      initialMonth: DateTime(2026, 7),
      selectedDate: DateTime(2026, 7, 22),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as `app_tag_use_cases.dart`'s interactive entry: knobs here
/// apply only to this one catalog entry, while
/// `apps/widgetbook/lib/addons/theme_studio_addon.dart`'s `ThemeStudioAddon`
/// remains the tool for a whole-catalog retheme. `context.knobs.dateTime`
/// drives the actual `selectedDate` constructor parameter directly (a
/// real Widgetbook knob type — no need to reinvent one); radius/color/
/// motion re-use the same `AppTheme.light(...)` override parameters
/// Theme Studio itself is built on.
@widgetbook.UseCase(name: 'Interactive', type: AppCalendar)
Widget appCalendarInteractiveUseCase(BuildContext context) {
  final selectedDate = context.knobs.dateTime(
    label: 'Selected date',
    initialValue: DateTime(2026, 7, 22),
    start: DateTime(2026),
    end: DateTime(2027, 12, 31),
  );
  final boundDates = context.knobs.boolean(
    label: 'Restrict to a 10-day range around today',
    initialValue: false,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — selected fill, today ring)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final radiusMultiplier = context.knobs.double.slider(
    label: 'Radius multiplier (outer popover shape)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (month cross-fade)',
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
      child: AppCalendar(
        initialMonth: DateTime(selectedDate.year, selectedDate.month),
        selectedDate: selectedDate,
        firstDate: boundDates
            ? selectedDate.subtract(const Duration(days: 5))
            : null,
        lastDate: boundDates ? selectedDate.add(const Duration(days: 5)) : null,
        onDateSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Popover (AppDatePicker.show)', type: AppDatePicker)
Widget appDatePickerShowUseCase(BuildContext context) {
  return Center(
    child: AppButton(
      label: 'Open date picker',
      onPressed: () =>
          AppDatePicker.show(context, initialDate: DateTime(2026, 7, 22)),
    ),
  );
}
