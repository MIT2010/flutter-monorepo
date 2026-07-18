import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: AppExpressiveCard)
Widget appExpressiveCardDefaultUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 260,
      child: AppExpressiveCard(
        onTap: () {},
        child: const Text('Tap to see the shape + elevation morph'),
      ),
    ),
  );
}
