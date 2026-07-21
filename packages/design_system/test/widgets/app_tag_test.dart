import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTag', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppTag(label: 'Filter')),
        ),
      );

      expect(find.text('Filter'), findsOneWidget);
    });

    testWidgets('shows no remove icon when onRemove is not given', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppTag(label: 'Filter')),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('tapping the tag body calls onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppTag(label: 'Filter', onTap: () => tapped = true),
          ),
        ),
      );

      await tester.tap(find.byType(AppTag));
      expect(tapped, isTrue);
    });

    testWidgets(
      'tapping the remove icon calls onRemove, not onTap -- a deliberate '
      'tap on the "x", not the same gesture as the tag body',
      (tester) async {
        var tapped = false;
        var removed = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppTag(
                label: 'Removable',
                onTap: () => tapped = true,
                onRemove: () => removed = true,
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.close));
        expect(removed, isTrue);
        expect(tapped, isFalse);
      },
    );

    testWidgets(
      'selected fills with primaryContainer, unselected has no fill',
      (tester) async {
        Future<Color?> fillOf({required bool selected}) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light(),
              home: Scaffold(
                body: AppTag(label: 'x', selected: selected),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));
          final container = tester.widget<AnimatedContainer>(
            find.byType(AnimatedContainer),
          );
          return (container.decoration as BoxDecoration).color;
        }

        final colorScheme = AppTheme.light().colorScheme;
        expect(await fillOf(selected: true), colorScheme.primaryContainer);
        expect(await fillOf(selected: false), isNull);
      },
    );
  });
}
