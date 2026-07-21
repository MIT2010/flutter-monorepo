import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppPasswordField golden', () {
    testWidgets('obscured, rest (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppPasswordField(label: 'Password'),
        ),
      );
      await expectLater(
        find.byType(AppPasswordField),
        matchesGoldenFile('goldens/app_password_field_obscured_light.png'),
      );
    });

    testWidgets('obscured, rest (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppPasswordField(label: 'Password'),
        ),
      );
      await expectLater(
        find.byType(AppPasswordField),
        matchesGoldenFile('goldens/app_password_field_obscured_dark.png'),
      );
    });

    testWidgets('revealed, settled back to rest tone (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppPasswordField(label: 'Password'),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      // Let the tap-flash (motion.micro, moss.60 -> stone.60) fully settle
      // before capturing -- otherwise this golden would be pinned to
      // whatever mid-flash frame happened to land, not the widget's real
      // rest state.
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppPasswordField),
        matchesGoldenFile('goldens/app_password_field_revealed_light.png'),
      );
    });

    testWidgets('revealed, settled back to rest tone (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppPasswordField(label: 'Password'),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppPasswordField),
        matchesGoldenFile('goldens/app_password_field_revealed_dark.png'),
      );
    });

    testWidgets('error (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppPasswordField(label: 'Password', errorText: 'Too short'),
        ),
      );
      await expectLater(
        find.byType(AppPasswordField),
        matchesGoldenFile('goldens/app_password_field_error_light.png'),
      );
    });

    testWidgets('error (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppPasswordField(label: 'Password', errorText: 'Too short'),
        ),
      );
      await expectLater(
        find.byType(AppPasswordField),
        matchesGoldenFile('goldens/app_password_field_error_dark.png'),
      );
    });
  });
}
