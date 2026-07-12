import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppCard golden', () {
    testWidgets('default (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 150),
        child: const SizedBox(
          width: 260,
          child: AppCard(child: Text('Card content')),
        ),
      );
      await expectLater(
        find.byType(AppCard),
        matchesGoldenFile('goldens/app_card_default_light.png'),
      );
    });

    testWidgets('default (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 150),
        child: const SizedBox(
          width: 260,
          child: AppCard(child: Text('Card content')),
        ),
      );
      await expectLater(
        find.byType(AppCard),
        matchesGoldenFile('goldens/app_card_default_dark.png'),
      );
    });
  });
}
