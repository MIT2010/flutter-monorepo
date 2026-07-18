import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'With action', type: AppEmptyState)
Widget appEmptyStateWithActionUseCase(BuildContext context) {
  return AppEmptyState(
    icon: Icons.inbox,
    message: 'Belum ada data',
    actionLabel: 'Muat ulang',
    onAction: () {},
  );
}

@widgetbook.UseCase(name: 'Without action', type: AppEmptyState)
Widget appEmptyStateWithoutActionUseCase(BuildContext context) {
  return const AppEmptyState(icon: Icons.search_off, message: 'Page not found');
}
