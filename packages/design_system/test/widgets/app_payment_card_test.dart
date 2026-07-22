import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPaymentCard', () {
    testWidgets('renders masked number, holder name, and network label', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppPaymentCard(
              maskedNumber: '•••• •••• •••• 4821',
              holderName: 'Aisha Putri',
              networkLabel: 'VISA',
            ),
          ),
        ),
      );

      expect(find.text('•••• •••• •••• 4821'), findsOneWidget);
      expect(find.text('AISHA PUTRI'), findsOneWidget);
      expect(find.text('VISA'), findsOneWidget);
      expect(find.text('Frozen'), findsNothing);
    });

    testWidgets('shows a Frozen tag only when frozen is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppPaymentCard(
              maskedNumber: '•••• •••• •••• 7790',
              holderName: 'Aisha Putri',
              networkLabel: 'MC',
              frozen: true,
            ),
          ),
        ),
      );

      expect(find.text('Frozen'), findsOneWidget);
    });

    testWidgets('accepts a custom fill color without throwing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) => Scaffold(
              body: AppPaymentCard(
                maskedNumber: '•••• •••• •••• 1122',
                holderName: 'Aisha Putri',
                networkLabel: 'MC',
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('holds a standard ID-1 card aspect ratio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: SizedBox(
              width: 320,
              child: AppPaymentCard(
                maskedNumber: '•••• •••• •••• 4821',
                holderName: 'Aisha Putri',
                networkLabel: 'VISA',
              ),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(AppPaymentCard));
      expect(size.width / size.height, closeTo(1.586, 0.01));
    });
  });
}
