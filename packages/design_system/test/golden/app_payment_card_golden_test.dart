import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppPaymentCard golden', () {
    testWidgets('primary fill, active (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(340, 220),
        child: const SizedBox(
          width: 320,
          child: AppPaymentCard(
            maskedNumber: '•••• •••• •••• 4821',
            holderName: 'Aisha Putri',
            networkLabel: 'VISA',
          ),
        ),
      );

      await expectLater(
        find.byType(AppPaymentCard),
        matchesGoldenFile('goldens/app_payment_card_primary_light.png'),
      );
    });

    testWidgets('primary fill, active (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(340, 220),
        child: const SizedBox(
          width: 320,
          child: AppPaymentCard(
            maskedNumber: '•••• •••• •••• 4821',
            holderName: 'Aisha Putri',
            networkLabel: 'VISA',
          ),
        ),
      );

      await expectLater(
        find.byType(AppPaymentCard),
        matchesGoldenFile('goldens/app_payment_card_primary_dark.png'),
      );
    });

    testWidgets('tertiary fill, frozen (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(340, 220),
        child: Builder(
          builder: (context) => SizedBox(
            width: 320,
            child: AppPaymentCard(
              maskedNumber: '•••• •••• •••• 7790',
              holderName: 'Aisha Putri',
              networkLabel: 'MC',
              frozen: true,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(AppPaymentCard),
        matchesGoldenFile('goldens/app_payment_card_tertiary_frozen_light.png'),
      );
    });

    testWidgets('tertiary fill, frozen (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(340, 220),
        child: Builder(
          builder: (context) => SizedBox(
            width: 320,
            child: AppPaymentCard(
              maskedNumber: '•••• •••• •••• 7790',
              holderName: 'Aisha Putri',
              networkLabel: 'MC',
              frozen: true,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(AppPaymentCard),
        matchesGoldenFile('goldens/app_payment_card_tertiary_frozen_dark.png'),
      );
    });
  });
}
