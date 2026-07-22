import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

const _items = [
  AppMenuItem(value: 'edit', label: 'Edit', icon: Icons.edit_outlined),
  AppMenuItem(
    value: 'duplicate',
    label: 'Duplicate',
    icon: Icons.copy_outlined,
  ),
  AppMenuItem(value: 'delete', label: 'Delete', icon: Icons.delete_outline),
];

Widget _trigger() => Builder(
  builder: (context) => TextButton(
    onPressed: () => AppMenu.show<String>(
      context,
      position: const Offset(20, 20),
      items: _items,
    ),
    child: const Text('Open'),
  ),
);

void main() {
  group('AppMenu golden', () {
    testWidgets('open -- Level 3 depth, radius.md, flat item hover tint '
        '(light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 220),
        child: _trigger(),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/app_menu_open_light.png'),
      );
    });

    testWidgets('open -- Level 3 depth, radius.md, flat item hover tint '
        '(dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 220),
        child: _trigger(),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/app_menu_open_dark.png'),
      );
    });
  });
}
