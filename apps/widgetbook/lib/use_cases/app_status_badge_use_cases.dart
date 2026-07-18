import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Success', type: AppStatusBadge)
Widget appStatusBadgeSuccessUseCase(BuildContext context) {
  return const Center(
    child: AppStatusBadge(
      label: 'Selesai',
      tone: AppStatusTone.success,
      icon: Icons.check,
    ),
  );
}

@widgetbook.UseCase(name: 'Warning', type: AppStatusBadge)
Widget appStatusBadgeWarningUseCase(BuildContext context) {
  return const Center(
    child: AppStatusBadge(label: 'Perhatian', tone: AppStatusTone.warning),
  );
}

@widgetbook.UseCase(name: 'Info', type: AppStatusBadge)
Widget appStatusBadgeInfoUseCase(BuildContext context) {
  return const Center(
    child: AppStatusBadge(label: 'Info', tone: AppStatusTone.info),
  );
}
