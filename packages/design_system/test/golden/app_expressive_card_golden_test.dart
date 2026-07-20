import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

/// Unlike the retired spring-physics design, the border-color-shift
/// mechanic (§5.4) is fully deterministic -- a pressed-state golden is
/// safe to capture (no longer "inherently non-deterministic frame to
/// frame", the reason a tapped-state golden used to be skipped here).
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

    testWidgets('pressed (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 150),
        child: SizedBox(
          width: 260,
          child: AppExpressiveCard(
            onTap: () {},
            child: const Text('Card content'),
          ),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppExpressiveCard)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await expectLater(
        find.byType(AppExpressiveCard),
        matchesGoldenFile('goldens/app_expressive_card_pressed_light.png'),
      );
      await gesture.up();
    });

    testWidgets('pressed (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 150),
        child: SizedBox(
          width: 260,
          child: AppExpressiveCard(
            onTap: () {},
            child: const Text('Card content'),
          ),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(AppExpressiveCard)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await expectLater(
        find.byType(AppExpressiveCard),
        matchesGoldenFile('goldens/app_expressive_card_pressed_dark.png'),
      );
      await gesture.up();
    });
  });
}
