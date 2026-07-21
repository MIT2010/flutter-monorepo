import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppTag golden', () {
    testWidgets('unselected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: const AppTag(label: 'Filter'),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_unselected_light.png'),
      );
    });

    testWidgets('unselected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: const AppTag(label: 'Filter'),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_unselected_dark.png'),
      );
    });

    testWidgets('selected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: const AppTag(label: 'Active', selected: true),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_selected_light.png'),
      );
    });

    testWidgets('selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: const AppTag(label: 'Active', selected: true),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_selected_dark.png'),
      );
    });

    testWidgets('removable (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: AppTag(label: 'Removable', onRemove: () {}),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_removable_light.png'),
      );
    });

    testWidgets('removable (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: AppTag(label: 'Removable', onRemove: () {}),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_removable_dark.png'),
      );
    });

    testWidgets('selected and removable (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: AppTag(label: 'Active', selected: true, onRemove: () {}),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_selected_removable_light.png'),
      );
    });

    testWidgets('selected and removable (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: AppTag(label: 'Active', selected: true, onRemove: () {}),
      );
      await expectLater(
        find.byType(AppTag),
        matchesGoldenFile('goldens/app_tag_selected_removable_dark.png'),
      );
    });
  });
}
