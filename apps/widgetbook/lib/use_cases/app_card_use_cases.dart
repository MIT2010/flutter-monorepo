import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: AppCard)
Widget appCardDefaultUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 260,
      child: AppCard(child: const Text('Card content')),
    ),
  );
}

@widgetbook.UseCase(name: 'Tappable', type: AppCard)
Widget appCardTappableUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 260,
      child: AppCard(onTap: () {}, child: const Text('Tap me')),
    ),
  );
}
