import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: AppLoadingIndicator)
Widget appLoadingIndicatorDefaultUseCase(BuildContext context) {
  return const AppLoadingIndicator();
}
