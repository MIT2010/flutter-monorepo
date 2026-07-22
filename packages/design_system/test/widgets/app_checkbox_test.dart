import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCheckbox', () {
    testWidgets('tapping unchecked calls onChanged(true)', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppCheckbox(value: false, onChanged: (v) => result = v),
          ),
        ),
      );

      await tester.tap(find.byType(AppCheckbox));
      expect(result, isTrue);
    });

    testWidgets('non-tristate: tapping checked calls onChanged(false)', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppCheckbox(value: true, onChanged: (v) => result = v),
          ),
        ),
      );

      await tester.tap(find.byType(AppCheckbox));
      expect(result, isFalse);
    });

    testWidgets(
      'tristate: cycles false -> true -> null -> false on repeated taps',
      (tester) async {
        bool? value = false;
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              theme: AppTheme.light(),
              home: Scaffold(
                body: AppCheckbox(
                  value: value,
                  tristate: true,
                  onChanged: (v) => setState(() => value = v),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(AppCheckbox));
        await tester.pump();
        expect(value, isTrue);

        await tester.tap(find.byType(AppCheckbox));
        await tester.pump();
        expect(value, isNull);

        await tester.tap(find.byType(AppCheckbox));
        await tester.pump();
        expect(value, isFalse);
      },
    );

    testWidgets('disabled (onChanged null) does not respond to taps', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppCheckbox(value: false, onChanged: null),
          ),
        ),
      );

      await tester.tap(find.byType(AppCheckbox));
      // No exception, no callback to observe -- this just proves the tap
      // doesn't crash reaching for a null onChanged.
      expect(find.byType(AppCheckbox), findsOneWidget);
    });

    testWidgets('checked shows a check icon, indeterminate shows a dash', (
      tester,
    ) async {
      Finder glyph(VerdantGlyph g) =>
          find.byWidgetPredicate((w) => w is VerdantIcon && w.glyph == g);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: AppCheckbox(value: true, onChanged: (_) {})),
        ),
      );
      expect(glyph(VerdantGlyph.check), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppCheckbox(value: null, tristate: true, onChanged: (_) {}),
          ),
        ),
      );
      expect(glyph(VerdantGlyph.remove), findsOneWidget);
    });

    testWidgets('unchecked shows no glyph', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: AppCheckbox(value: false, onChanged: (_) {})),
        ),
      );
      expect(find.byType(VerdantIcon), findsNothing);
    });
  });
}
