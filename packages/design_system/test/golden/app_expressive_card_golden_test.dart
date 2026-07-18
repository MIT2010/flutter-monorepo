import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

/// Only the rest (untapped) state is captured -- the tapped/mid-spring
/// state is inherently non-deterministic frame-to-frame, unsuitable for a
/// pixel-diff golden. `app_expressive_card_test.dart` covers the
/// animation behavior itself (including the reduce-motion path).
void main() {
  group('AppExpressiveCard golden', () {
    testWidgets('default (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 150),
        child: const SizedBox(
          width: 260,
          child: AppExpressiveCard(child: Text('Card content')),
        ),
      );
      await expectLater(
        find.byType(AppExpressiveCard),
        matchesGoldenFile('goldens/app_expressive_card_default_light.png'),
      );
    });

    testWidgets('default (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 150),
        child: const SizedBox(
          width: 260,
          child: AppExpressiveCard(child: Text('Card content')),
        ),
      );
      await expectLater(
        find.byType(AppExpressiveCard),
        matchesGoldenFile('goldens/app_expressive_card_default_dark.png'),
      );
    });
  });
}
