import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppTextField golden', () {
    testWidgets('default (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(width: 280, child: AppTextField(label: 'Email')),
      );
      await expectLater(
        find.byType(AppTextField),
        matchesGoldenFile('goldens/app_text_field_default_light.png'),
      );
    });

    testWidgets('default (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(width: 280, child: AppTextField(label: 'Email')),
      );
      await expectLater(
        find.byType(AppTextField),
        matchesGoldenFile('goldens/app_text_field_default_dark.png'),
      );
    });

    testWidgets('error (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppTextField(
            label: 'Email',
            errorText: 'Format email tidak valid',
          ),
        ),
      );
      await expectLater(
        find.byType(AppTextField),
        matchesGoldenFile('goldens/app_text_field_error_light.png'),
      );
    });

    testWidgets('error (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppTextField(
            label: 'Email',
            errorText: 'Format email tidak valid',
          ),
        ),
      );
      await expectLater(
        find.byType(AppTextField),
        matchesGoldenFile('goldens/app_text_field_error_dark.png'),
      );
    });

    testWidgets('obscured (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppTextField(label: 'Password', obscure: true),
        ),
      );
      await expectLater(
        find.byType(AppTextField),
        matchesGoldenFile('goldens/app_text_field_obscure_light.png'),
      );
    });

    testWidgets('obscured (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 100),
        child: const SizedBox(
          width: 280,
          child: AppTextField(label: 'Password', obscure: true),
        ),
      );
      await expectLater(
        find.byType(AppTextField),
        matchesGoldenFile('goldens/app_text_field_obscure_dark.png'),
      );
    });
  });
}
