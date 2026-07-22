import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _glyph(VerdantGlyph g) =>
    find.byWidgetPredicate((w) => w is VerdantIcon && w.glyph == g);

void main() {
  group('AppSearchField', () {
    testWidgets('renders no persistent label -- the leading icon is the '
        'label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppSearchField()),
        ),
      );

      expect(_glyph(VerdantGlyph.search), findsOneWidget);
      // No persistent label row above the field -- only the hint text
      // (rendered inside the field itself, styled quite differently from
      // a label) says "Search" by default.
      final decoration = tester
          .widget<TextField>(find.byType(TextField))
          .decoration;
      expect(decoration?.hintText, 'Search');
    });

    testWidgets('shows the hintText as a placeholder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppSearchField(hintText: 'Cari produk')),
        ),
      );

      expect(find.text('Cari produk'), findsOneWidget);
    });

    testWidgets('clear button is hidden when empty, appears once text is '
        'entered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppSearchField()),
        ),
      );

      expect(_glyph(VerdantGlyph.close), findsNothing);

      await tester.enterText(find.byType(TextField), 'sepatu');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      expect(_glyph(VerdantGlyph.close), findsOneWidget);
    });

    testWidgets('tapping clear empties the field and hides the button '
        'again', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppSearchField()),
        ),
      );

      await tester.enterText(find.byType(TextField), 'sepatu');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      await tester.tap(_glyph(VerdantGlyph.close));
      // AnimatedSwitcher keeps the outgoing "clear" icon in the tree for
      // the duration of its own fade-out, and needs a settle pump beyond
      // that exact duration to actually drop it -- pumping precisely
      // motion.durationMicro left it findsOneWidget still, confirmed by
      // instrumenting this exact assertion before widening the margin.
      await tester.pumpAndSettle();

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, isEmpty);
      expect(_glyph(VerdantGlyph.close), findsNothing);
    });

    testWidgets('onChanged reports typed text', (tester) async {
      String? changed;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: AppSearchField(onChanged: (v) => changed = v)),
        ),
      );

      await tester.enterText(find.byType(TextField), 'query');
      expect(changed, 'query');
    });

    testWidgets('works with an externally-provided controller', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: AppSearchField(controller: controller)),
        ),
      );

      controller.text = 'preset';
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      expect(_glyph(VerdantGlyph.close), findsOneWidget);
    });
  });
}
