import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCalendar', () {
    testWidgets('shows the initial month\'s name and year', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: AppCalendar(initialMonth: DateTime(2026, 7))),
        ),
      );

      expect(find.text('July 2026'), findsOneWidget);
    });

    testWidgets('next/previous chevrons navigate months', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: AppCalendar(initialMonth: DateTime(2026, 7))),
        ),
      );

      final chevronRight = find.byWidgetPredicate(
        (w) => w is VerdantIcon && w.glyph == VerdantGlyph.chevronRight,
      );
      final chevronLeft = find.byWidgetPredicate(
        (w) => w is VerdantIcon && w.glyph == VerdantGlyph.chevronLeft,
      );

      await tester.tap(chevronRight);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('August 2026'), findsOneWidget);

      await tester.tap(chevronLeft);
      await tester.tap(chevronLeft);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('June 2026'), findsOneWidget);
    });

    testWidgets('tapping a day calls onDateSelected with that date', (
      tester,
    ) async {
      DateTime? picked;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppCalendar(
              initialMonth: DateTime(2026, 7),
              onDateSelected: (date) => picked = date,
            ),
          ),
        ),
      );

      await tester.tap(find.text('15'));
      expect(picked, DateTime(2026, 7, 15));
    });

    testWidgets('a date outside firstDate/lastDate is not tappable', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppCalendar(
              initialMonth: DateTime(2026, 7),
              firstDate: DateTime(2026, 7, 10),
              lastDate: DateTime(2026, 7, 20),
              onDateSelected: (date) => tapped = true,
            ),
          ),
        ),
      );

      // '5' is before firstDate -- every day-cell InkWell with a null
      // onTap simply does nothing when tapped, which is what this
      // proves: no callback fires for an out-of-range day.
      await tester.tap(find.text('5'));
      expect(tapped, isFalse);
    });

    testWidgets(
      'a day that is both today and selected renders filled, not ringed '
      '-- selected takes priority once a date is actually chosen',
      (tester) async {
        final fixedToday = DateTime(2026, 7, 15);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppCalendar(
                initialMonth: fixedToday,
                today: fixedToday,
                selectedDate: fixedToday,
              ),
            ),
          ),
        );

        final container = tester.widget<AnimatedContainer>(
          find
              .ancestor(
                of: find.text('15'),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        final decoration = container.decoration as BoxDecoration;
        final colorScheme = AppTheme.light().colorScheme;

        expect(decoration.color, colorScheme.primary);
        expect(decoration.border, isNull);
      },
    );
  });

  group('AppDatePicker.show', () {
    testWidgets('resolves with the tapped date', (tester) async {
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => AppButton(
                label: 'Open',
                onPressed: () async {
                  result = await AppDatePicker.show(
                    context,
                    initialDate: DateTime(2026, 7, 15),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('22'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(result, DateTime(2026, 7, 22));
    });
  });
}
