import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEmptyState', () {
    testWidgets('renders the icon and message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppEmptyState(icon: Icons.inbox, message: 'Belum ada data'),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('Belum ada data'), findsOneWidget);
    });

    testWidgets('omits the action button when actionLabel/onAction are null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppEmptyState(icon: Icons.inbox, message: 'Belum ada data'),
          ),
        ),
      );

      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('shows and fires the action button when both are given', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppEmptyState(
              icon: Icons.inbox,
              message: 'Belum ada data',
              actionLabel: 'Muat ulang',
              onAction: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Muat ulang'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
