import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppTooltip golden', () {
    testWidgets('visible after long-press -- the inverted register (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 200),
        child: const AppTooltip(
          message: 'Delete this item',
          child: Icon(Icons.delete_outline),
        ),
      );

      await tester.longPress(find.byType(AppTooltip));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/app_tooltip_visible_light.png'),
      );
    });

    testWidgets('visible after long-press -- the inverted register (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 200),
        child: const AppTooltip(
          message: 'Delete this item',
          child: Icon(Icons.delete_outline),
        ),
      );

      await tester.longPress(find.byType(AppTooltip));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/app_tooltip_visible_dark.png'),
      );
    });
  });
}
