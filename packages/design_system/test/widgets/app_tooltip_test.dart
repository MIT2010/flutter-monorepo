import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTooltip', () {
    testWidgets('renders the child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppTooltip(
              message: 'Delete this item',
              child: Icon(Icons.delete),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('long-press reveals the message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppTooltip(
              message: 'Delete this item',
              child: Icon(Icons.delete),
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(AppTooltip));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Delete this item'), findsOneWidget);
    });

    testWidgets('uses the inverted onSurface/surface pairing, not the normal '
        'floating register', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppTooltip(
              message: 'Delete this item',
              child: Icon(Icons.delete),
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(AppTooltip));
      await tester.pump(const Duration(milliseconds: 50));

      final colorScheme = AppTheme.light().colorScheme;
      final tooltipWidget = tester.widget<Tooltip>(find.byType(Tooltip));
      final decoration = tooltipWidget.decoration as BoxDecoration;
      expect(decoration.color, colorScheme.onSurface);
      expect(tooltipWidget.textStyle!.color, colorScheme.surface);
    });
  });
}
