import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

const _items = [
  AppDropdownItem(value: 'id', label: 'Indonesia'),
  AppDropdownItem(value: 'my', label: 'Malaysia'),
  AppDropdownItem(value: 'sg', label: 'Singapore'),
];

void main() {
  group('AppDropdown golden', () {
    testWidgets('closed, unselected -- shows hintText (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: null,
            items: _items,
            hintText: 'Select a country',
          ),
        ),
      );
      await expectLater(
        find.byType(AppDropdown<String>),
        matchesGoldenFile('goldens/app_dropdown_closed_unselected_light.png'),
      );
    });

    testWidgets('closed, unselected -- shows hintText (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: null,
            items: _items,
            hintText: 'Select a country',
          ),
        ),
      );
      await expectLater(
        find.byType(AppDropdown<String>),
        matchesGoldenFile('goldens/app_dropdown_closed_unselected_dark.png'),
      );
    });

    testWidgets('closed, with a selected value (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: 'my',
            items: _items,
          ),
        ),
      );
      await expectLater(
        find.byType(AppDropdown<String>),
        matchesGoldenFile('goldens/app_dropdown_closed_selected_light.png'),
      );
    });

    testWidgets('closed, with a selected value (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: 'my',
            items: _items,
          ),
        ),
      );
      await expectLater(
        find.byType(AppDropdown<String>),
        matchesGoldenFile('goldens/app_dropdown_closed_selected_dark.png'),
      );
    });

    testWidgets('open -- Level 3 option list anchored below (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 260),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: 'my',
            items: _items,
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/app_dropdown_open_light.png'),
      );
    });

    testWidgets('open -- Level 3 option list anchored below (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 260),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: 'my',
            items: _items,
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/app_dropdown_open_dark.png'),
      );
    });

    testWidgets('error (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: null,
            items: _items,
            errorText: 'Required',
          ),
        ),
      );
      await expectLater(
        find.byType(AppDropdown<String>),
        matchesGoldenFile('goldens/app_dropdown_error_light.png'),
      );
    });

    testWidgets('error (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppDropdown<String>(
            label: 'Country',
            value: null,
            items: _items,
            errorText: 'Required',
          ),
        ),
      );
      await expectLater(
        find.byType(AppDropdown<String>),
        matchesGoldenFile('goldens/app_dropdown_error_dark.png'),
      );
    });
  });
}
