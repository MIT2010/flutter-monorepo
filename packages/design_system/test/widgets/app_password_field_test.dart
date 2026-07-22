import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppPasswordField', () {
    testWidgets('starts obscured', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppPasswordField(label: 'Password')),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isTrue);
      expect(
        find.byWidgetPredicate(
          (w) => w is VerdantIcon && w.glyph == VerdantGlyph.eye,
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping the toggle reveals text and swaps the glyph', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppPasswordField(label: 'Password')),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isFalse);
      expect(
        find.byWidgetPredicate(
          (w) => w is VerdantIcon && w.glyph == VerdantGlyph.eyeOff,
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping again re-obscures', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppPasswordField(label: 'Password')),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isTrue);
    });

    testWidgets(
      'the toggle icon flashes to primary on tap, then settles back to '
      'onSurfaceVariant',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: AppPasswordField(label: 'Password')),
          ),
        );

        final colorScheme = AppTheme.light().colorScheme;

        await tester.tap(find.byType(IconButton));
        await tester.pump();
        final flashed = tester.widget<VerdantIcon>(find.byType(VerdantIcon));
        expect(flashed.color, colorScheme.primary);

        await tester.pump(const Duration(milliseconds: 120));
        final settled = tester.widget<VerdantIcon>(find.byType(VerdantIcon));
        expect(settled.color, colorScheme.onSurfaceVariant);
      },
    );

    testWidgets('onChanged reports typed text', (tester) async {
      String? changed;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppPasswordField(
              label: 'Password',
              onChanged: (v) => changed = v,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'hunter2');
      expect(changed, 'hunter2');
    });

    testWidgets('errorText is forwarded to the underlying field', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppPasswordField(label: 'Password', errorText: 'Too short'),
          ),
        ),
      );

      expect(find.text('Too short'), findsOneWidget);
    });
  });
}
