import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _items = [
  AppDropdownItem(value: 'id', label: 'Indonesia'),
  AppDropdownItem(value: 'my', label: 'Malaysia'),
  AppDropdownItem(value: 'sg', label: 'Singapore'),
];

void main() {
  group('AppDropdown', () {
    testWidgets('shows the selected value\'s label in the trigger', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppDropdown<String>(
              label: 'Country',
              value: 'my',
              items: _items,
            ),
          ),
        ),
      );

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, 'Malaysia');
      expect(field.readOnly, isTrue);
    });

    testWidgets('tapping the trigger opens the option list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppDropdown<String>(
              label: 'Country',
              value: null,
              items: _items,
            ),
          ),
        ),
      );

      expect(find.text('Singapore'), findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Indonesia'), findsOneWidget);
      expect(find.text('Malaysia'), findsOneWidget);
      expect(find.text('Singapore'), findsOneWidget);
    });

    testWidgets('selecting an option calls onChanged and closes the list', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppDropdown<String>(
              label: 'Country',
              value: null,
              items: _items,
              onChanged: (v) => selected = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      await tester.tap(find.text('Singapore'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(selected, 'sg');
      expect(find.text('Indonesia'), findsNothing);
    });

    testWidgets('tapping the trigger again closes an already-open list', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppDropdown<String>(
              label: 'Country',
              value: null,
              items: _items,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Indonesia'), findsOneWidget);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(find.text('Indonesia'), findsNothing);
    });

    testWidgets('chevron rotates 180deg on open', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppDropdown<String>(
              label: 'Country',
              value: null,
              items: _items,
            ),
          ),
        ),
      );

      final closed = tester.widget<AnimatedRotation>(
        find.byType(AnimatedRotation),
      );
      expect(closed.turns, 0);

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final open = tester.widget<AnimatedRotation>(
        find.byType(AnimatedRotation),
      );
      expect(open.turns, 0.5);
    });

    testWidgets('errorText is forwarded to the underlying field', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppDropdown<String>(
              label: 'Country',
              value: null,
              items: _items,
              errorText: 'Required',
            ),
          ),
        ),
      );

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('disposing while the list is open does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppDropdown<String>(
              label: 'Country',
              value: null,
              items: _items,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  });
}
