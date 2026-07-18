import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// [AppDialog.confirm] is a static helper, not a widget of its own — the
/// use case shows a real trigger button, same reasoning as
/// `test/golden/app_dialog_golden_test.dart`'s `_openConfirmDialog`.
@widgetbook.UseCase(name: 'Confirm', type: AppDialog)
Widget appDialogConfirmUseCase(BuildContext context) {
  return Center(
    child: Builder(
      builder: (context) => AppButton(
        label: 'Open confirm dialog',
        onPressed: () => AppDialog.confirm(
          context,
          title: 'Keluar?',
          message: 'Perubahan yang belum disimpan akan hilang.',
          confirmLabel: 'Keluar',
          cancelLabel: 'Batal',
        ),
      ),
    ),
  );
}
