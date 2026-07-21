import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

@widgetbook.UseCase(name: 'Empty', type: AppOtpField)
Widget appOtpFieldEmptyUseCase(BuildContext context) {
  return const Center(child: AppOtpField(length: 6));
}

@widgetbook.UseCase(name: 'Error', type: AppOtpField)
Widget appOtpFieldErrorUseCase(BuildContext context) {
  return const Center(
    child: AppOtpField(length: 6, errorText: 'Kode tidak valid'),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. [AppOtpField.length] itself is
/// knob-driven too, since a fixed-length code is the one parameter every
/// real consumer would actually vary (4-digit vs. 6-digit is a common
/// split across OTP providers).
@widgetbook.UseCase(name: 'Interactive', type: AppOtpField)
Widget appOtpFieldInteractiveUseCase(BuildContext context) {
  final length = context.knobs.int.slider(
    label: 'Code length',
    initialValue: 6,
    min: 4,
    max: 8,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — focused-cell border)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final radiusMultiplier = context.knobs.double.slider(
    label: 'Radius multiplier (per-cell radius.xs)',
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
    ),
    child: Center(
      child: AppOtpField(
        length: length,
        onChanged: (_) {},
        onCompleted: (_) {},
      ),
    ),
  );
}
