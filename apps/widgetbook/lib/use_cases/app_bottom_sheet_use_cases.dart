import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// [AppBottomSheet.show] is a static helper, not a widget of its own — the
/// use case shows a real trigger button, same reasoning as
/// `test/golden/app_bottom_sheet_golden_test.dart`'s `_openBottomSheet`.
@widgetbook.UseCase(name: 'Default', type: AppBottomSheet)
Widget appBottomSheetDefaultUseCase(BuildContext context) {
  return Center(
    child: Builder(
      builder: (context) => AppButton(
        label: 'Open bottom sheet',
        onPressed: () => AppBottomSheet.show(
          context,
          builder: (_) => const SizedBox(
            height: 160,
            child: Center(child: Text('Sheet content')),
          ),
        ),
      ),
    ),
  );
}
