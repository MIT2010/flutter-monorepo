import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppSearchField golden', () {
    testWidgets('empty (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(width: 280, child: AppSearchField()),
      );
      await expectLater(
        find.byType(AppSearchField),
        matchesGoldenFile('goldens/app_search_field_empty_light.png'),
      );
    });

    testWidgets('empty (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(width: 280, child: AppSearchField()),
      );
      await expectLater(
        find.byType(AppSearchField),
        matchesGoldenFile('goldens/app_search_field_empty_dark.png'),
      );
    });

    testWidgets('with text -- clear button visible (light)', (tester) async {
      // Pre-populated via controller, never `tester.enterText` -- entering
      // text requests real focus and starts the cursor blink timer, which
      // is not something a golden capture can pin deterministically (the
      // same reasoning `golden_harness.dart` already applies elsewhere).
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: SizedBox(
          width: 280,
          child: AppSearchField(
            controller: TextEditingController(text: 'Sepatu lari'),
          ),
        ),
      );
      await expectLater(
        find.byType(AppSearchField),
        matchesGoldenFile('goldens/app_search_field_with_text_light.png'),
      );
    });

    testWidgets('with text -- clear button visible (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: SizedBox(
          width: 280,
          child: AppSearchField(
            controller: TextEditingController(text: 'Sepatu lari'),
          ),
        ),
      );
      await expectLater(
        find.byType(AppSearchField),
        matchesGoldenFile('goldens/app_search_field_with_text_dark.png'),
      );
    });
  });
}
