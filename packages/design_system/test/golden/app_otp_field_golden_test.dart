import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppOtpField golden', () {
    testWidgets('empty (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const AppOtpField(length: 6),
      );
      await expectLater(
        find.byType(AppOtpField),
        matchesGoldenFile('goldens/app_otp_field_empty_light.png'),
      );
    });

    testWidgets('empty (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const AppOtpField(length: 6),
      );
      await expectLater(
        find.byType(AppOtpField),
        matchesGoldenFile('goldens/app_otp_field_empty_dark.png'),
      );
    });

    testWidgets('filled, unfocused (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const AppOtpField(length: 6),
      );

      for (var i = 0; i < 6; i++) {
        await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
        await tester.pump();
      }
      // Explicitly drop focus before capturing -- otherwise whichever
      // cell auto-advance last landed on would still show a blinking
      // text cursor, which (like AppSearchField's clear-button fade) is
      // not something a golden capture can pin deterministically.
      // `InputDecorator`'s own focused-border-color transition is itself
      // a ~200ms implicit animation, unrelated to this widget's motion
      // tokens -- one zero-duration pump left a stray green border on
      // whichever cell had focus (caught by actually looking at the
      // rendered PNG, not just trusting green tests: it *looked* wrong
      // even though nothing asserted on border color).
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AppOtpField),
        matchesGoldenFile('goldens/app_otp_field_filled_light.png'),
      );
    });

    testWidgets('filled, unfocused (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const AppOtpField(length: 6),
      );

      for (var i = 0; i < 6; i++) {
        await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
        await tester.pump();
      }
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      await expectLater(
        find.byType(AppOtpField),
        matchesGoldenFile('goldens/app_otp_field_filled_dark.png'),
      );
    });

    testWidgets('error -- every cell border shifts together (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const AppOtpField(length: 6, errorText: 'Kode salah'),
      );
      await expectLater(
        find.byType(AppOtpField),
        matchesGoldenFile('goldens/app_otp_field_error_light.png'),
      );
    });

    testWidgets('error -- every cell border shifts together (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const AppOtpField(length: 6, errorText: 'Kode salah'),
      );
      await expectLater(
        find.byType(AppOtpField),
        matchesGoldenFile('goldens/app_otp_field_error_dark.png'),
      );
    });
  });
}
