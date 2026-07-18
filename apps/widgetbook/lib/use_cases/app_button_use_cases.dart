import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: AppButton)
Widget appButtonDefaultUseCase(BuildContext context) {
  return Center(
    child: AppButton(label: 'Login', onPressed: () {}),
  );
}

@widgetbook.UseCase(name: 'Loading', type: AppButton)
Widget appButtonLoadingUseCase(BuildContext context) {
  return Center(
    child: AppButton(label: 'Login', onPressed: () {}, loading: true),
  );
}

@widgetbook.UseCase(name: 'With icon', type: AppButton)
Widget appButtonWithIconUseCase(BuildContext context) {
  return Center(
    child: AppButton(
      label: 'Continue',
      onPressed: () {},
      icon: Icons.arrow_forward,
    ),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: AppButton)
Widget appButtonDisabledUseCase(BuildContext context) {
  return const Center(child: AppButton(label: 'Login', onPressed: null));
}
