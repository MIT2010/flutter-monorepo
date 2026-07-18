import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: AppTextField)
Widget appTextFieldDefaultUseCase(BuildContext context) {
  return Center(
    child: SizedBox(width: 280, child: AppTextField(label: 'Email')),
  );
}

@widgetbook.UseCase(name: 'Error', type: AppTextField)
Widget appTextFieldErrorUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 280,
      child: AppTextField(
        label: 'Email',
        errorText: 'Format email tidak valid',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Obscured', type: AppTextField)
Widget appTextFieldObscuredUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 280,
      child: AppTextField(label: 'Password', obscure: true),
    ),
  );
}
