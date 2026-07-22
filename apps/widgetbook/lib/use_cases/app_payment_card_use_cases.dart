import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Primary fill, active', type: AppPaymentCard)
Widget appPaymentCardPrimaryUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 340,
      child: AppPaymentCard(
        maskedNumber: '•••• •••• •••• 4821',
        holderName: 'Aisha Putri',
        networkLabel: 'VISA',
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Tertiary fill, frozen', type: AppPaymentCard)
Widget appPaymentCardFrozenUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 340,
      child: AppPaymentCard(
        maskedNumber: '•••• •••• •••• 7790',
        holderName: 'Aisha Putri',
        networkLabel: 'MC',
        frozen: true,
        color: Theme.of(context).colorScheme.tertiary,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: AppPaymentCard)
Widget appPaymentCardInteractiveUseCase(BuildContext context) {
  final frozen = context.knobs.boolean(label: 'Frozen', initialValue: false);
  final useTertiary = context.knobs.boolean(
    label: 'Use tertiary fill',
    initialValue: false,
  );
  final network = context.knobs.object.dropdown(
    label: 'Network',
    options: const ['VISA', 'MC'],
    initialOption: 'VISA',
  );

  return Center(
    child: SizedBox(
      width: 340,
      child: AppPaymentCard(
        maskedNumber: '•••• •••• •••• 4821',
        holderName: 'Aisha Putri',
        networkLabel: network,
        frozen: frozen,
        color: useTertiary ? Theme.of(context).colorScheme.tertiary : null,
      ),
    ),
  );
}
