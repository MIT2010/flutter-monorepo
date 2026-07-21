import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

// Fixed reference date -- a golden test can't assert against whatever day
// the suite happens to run on (see AppCalendar.today's own doc comment,
// added specifically because this test needed it).
final _fixedToday = DateTime(2026, 7, 15);

void main() {
  group('AppCalendar golden', () {
    testWidgets('default month grid, with today ring (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 360),
        child: AppCalendar(initialMonth: _fixedToday, today: _fixedToday),
      );
      await expectLater(
        find.byType(AppCalendar),
        matchesGoldenFile('goldens/app_calendar_default_light.png'),
      );
    });

    testWidgets('default month grid, with today ring (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 360),
        child: AppCalendar(initialMonth: _fixedToday, today: _fixedToday),
      );
      await expectLater(
        find.byType(AppCalendar),
        matchesGoldenFile('goldens/app_calendar_default_dark.png'),
      );
    });

    testWidgets('with a selected date (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 360),
        child: AppCalendar(
          initialMonth: _fixedToday,
          today: _fixedToday,
          selectedDate: DateTime(2026, 7, 22),
        ),
      );
      await expectLater(
        find.byType(AppCalendar),
        matchesGoldenFile('goldens/app_calendar_selected_light.png'),
      );
    });

    testWidgets('with a selected date (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 360),
        child: AppCalendar(
          initialMonth: _fixedToday,
          today: _fixedToday,
          selectedDate: DateTime(2026, 7, 22),
        ),
      );
      await expectLater(
        find.byType(AppCalendar),
        matchesGoldenFile('goldens/app_calendar_selected_dark.png'),
      );
    });

    testWidgets(
      'with a date-range boundary dimming out-of-range days (light)',
      (tester) async {
        await pumpGolden(
          tester,
          theme: lightTheme,
          surfaceSize: const Size(320, 360),
          child: AppCalendar(
            initialMonth: _fixedToday,
            today: _fixedToday,
            firstDate: DateTime(2026, 7, 10),
            lastDate: DateTime(2026, 7, 20),
          ),
        );
        await expectLater(
          find.byType(AppCalendar),
          matchesGoldenFile('goldens/app_calendar_bounded_light.png'),
        );
      },
    );

    testWidgets('with a date-range boundary dimming out-of-range days (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 360),
        child: AppCalendar(
          initialMonth: _fixedToday,
          today: _fixedToday,
          firstDate: DateTime(2026, 7, 10),
          lastDate: DateTime(2026, 7, 20),
        ),
      );
      await expectLater(
        find.byType(AppCalendar),
        matchesGoldenFile('goldens/app_calendar_bounded_dark.png'),
      );
    });
  });

  group('AppDatePicker golden', () {
    testWidgets('popover chrome — Level 3 depth, radius.md (light)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: AppButton(
                  label: 'Open',
                  onPressed: () => AppDatePicker.show(
                    context,
                    initialDate: DateTime(2026, 7, 22),
                    today: _fixedToday,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await expectLater(
        find.byType(AppCalendar),
        matchesGoldenFile('goldens/app_date_picker_popover_light.png'),
      );
    });

    testWidgets('popover chrome — Level 3 depth, radius.md (dark)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: AppButton(
                  label: 'Open',
                  onPressed: () => AppDatePicker.show(
                    context,
                    initialDate: DateTime(2026, 7, 22),
                    today: _fixedToday,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await expectLater(
        find.byType(AppCalendar),
        matchesGoldenFile('goldens/app_date_picker_popover_dark.png'),
      );
    });
  });
}
