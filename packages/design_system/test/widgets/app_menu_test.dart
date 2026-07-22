import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  AppMenuItem(value: 'edit', label: 'Edit', icon: Icons.edit_outlined),
  AppMenuItem(value: 'delete', label: 'Delete', icon: Icons.delete_outline),
];

void main() {
  group('AppMenu', () {
    testWidgets('shows every item label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => AppMenu.show<String>(
                  context,
                  position: const Offset(50, 50),
                  items: _items,
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('tapping an item resolves show() with its value', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  selected = await AppMenu.show<String>(
                    context,
                    position: const Offset(50, 50),
                    items: _items,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      await tester.tap(find.text('Delete'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(selected, 'delete');
    });

    testWidgets('tapping the barrier dismisses with a null result', (
      tester,
    ) async {
      String? result = 'unset';
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  result = await AppMenu.show<String>(
                    context,
                    position: const Offset(50, 50),
                    items: _items,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Tap far from the menu's anchored (50, 50) position to hit the
      // barrier instead -- (700, 700) originally missed the default
      // 800x600 test surface entirely and this assertion never actually
      // exercised the barrier at all, caught by the result staying
      // 'unset' instead of becoming null.
      await tester.tapAt(const Offset(10, 400));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(result, isNull);
    });

    testWidgets(
      'opens correctly when the calling context sits under a nested Theme '
      'override, not just the root MaterialApp theme -- regression test: '
      'showGeneralDialog (unlike showDialog) does not automatically '
      'replay the calling context\'s InheritedTheme into its new route, '
      'so a nested Theme override (e.g. a theme-preview tool\'s live color '
      'knob) previously crashed with "AppShapeExtension not found in '
      'ThemeData.extensions" -- caught by actually opening this in a '
      'running app, not from any golden test, which only ever exercises '
      'a single flat MaterialApp(theme: AppTheme.light())',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            // Deliberately not AppTheme.light() -- the root has none of
            // design_system's extensions, simulating an app shell (or a
            // theme-preview tool's own chrome) that isn't itself design_system-themed.
            theme: ThemeData(useMaterial3: true),
            home: Scaffold(
              body: Theme(
                data: AppTheme.light(),
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () => AppMenu.show<String>(
                      context,
                      position: const Offset(50, 50),
                      items: _items,
                    ),
                    child: const Text('Open'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));

        expect(tester.takeException(), isNull);
        expect(find.text('Edit'), findsOneWidget);
      },
    );
  });
}
