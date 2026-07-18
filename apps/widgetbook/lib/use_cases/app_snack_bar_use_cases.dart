import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// AppSnackBar is a static helper, not a widget -- this use case wraps its
/// own Scaffold (for a ScaffoldMessenger ancestor) with one button per tone
/// so each can be triggered and inspected directly in the catalog.
@widgetbook.UseCase(name: 'Variants', type: AppSnackBar)
Widget appSnackBarVariantsUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () =>
                AppSnackBar.showError(context, 'Gagal memuat data'),
            child: const Text('Show error'),
          ),
          ElevatedButton(
            onPressed: () =>
                AppSnackBar.showSuccess(context, 'Berhasil disimpan'),
            child: const Text('Show success'),
          ),
          ElevatedButton(
            onPressed: () => AppSnackBar.showInfo(context, 'Informasi'),
            child: const Text('Show info'),
          ),
        ],
      ),
    ),
  );
}
