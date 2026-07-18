import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'With action', type: AppStateView)
Widget appStateViewWithActionUseCase(BuildContext context) {
  return AppStateView(
    icon: Icons.inbox,
    message: 'Belum ada data',
    actionLabel: 'Muat ulang',
    onAction: () {},
  );
}

@widgetbook.UseCase(name: 'Without action', type: AppStateView)
Widget appStateViewWithoutActionUseCase(BuildContext context) {
  return const AppStateView(icon: Icons.search_off, message: 'Page not found');
}

@widgetbook.UseCase(name: 'Loading', type: AppStateView)
Widget appStateViewLoadingUseCase(BuildContext context) {
  return const AppStateView(
    loading: true,
    message: 'Menunggu konfirmasi pembayaran.',
  );
}

@widgetbook.UseCase(name: 'Error with retry', type: AppStateView)
Widget appStateViewErrorUseCase(BuildContext context) {
  return AppStateView(
    icon: Icons.error_outline,
    message: 'Gagal memuat data',
    tone: AppStateViewTone.error,
    actionLabel: 'Coba lagi',
    onAction: () {},
  );
}
