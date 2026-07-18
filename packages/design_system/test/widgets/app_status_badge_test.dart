import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStatusBadge', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppStatusBadge(label: 'Selesai', tone: AppStatusTone.success),
          ),
        ),
      );

      expect(find.text('Selesai'), findsOneWidget);
    });

    testWidgets('renders an icon when given one', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppStatusBadge(
              label: 'Perhatian',
              tone: AppStatusTone.warning,
              icon: Icons.warning,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('each tone fills with its matching AppSemanticColors role', (
      tester,
    ) async {
      Future<Color?> fillOf(AppStatusTone tone) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppStatusBadge(label: 'x', tone: tone),
            ),
          ),
        );
        final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
        return (box.decoration as BoxDecoration).color;
      }

      const colors = AppSemanticColors.light;
      expect(await fillOf(AppStatusTone.success), colors.success);
      expect(await fillOf(AppStatusTone.warning), colors.warning);
      expect(await fillOf(AppStatusTone.info), colors.info);
    });
  });
}
