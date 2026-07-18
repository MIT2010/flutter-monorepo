import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppLoadingIndicator golden', () {
    testWidgets('default (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(100, 100),
        child: const AppLoadingIndicator(),
      );
      await expectLater(
        find.byType(AppLoadingIndicator),
        matchesGoldenFile('goldens/app_loading_indicator_light.png'),
      );
    });

    testWidgets('default (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(100, 100),
        child: const AppLoadingIndicator(),
      );
      await expectLater(
        find.byType(AppLoadingIndicator),
        matchesGoldenFile('goldens/app_loading_indicator_dark.png'),
      );
    });
  });
}
