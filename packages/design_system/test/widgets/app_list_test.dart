import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppList', () {
    testWidgets('does not eagerly build every row for a large itemCount', (
      tester,
    ) async {
      var builtCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppList(
              itemCount: 50000,
              itemBuilder: (context, index) {
                builtCount++;
                return SizedBox(height: 48, child: Text('Row $index'));
              },
            ),
          ),
        ),
      );

      // A ~800px-tall test surface holding 48px rows only needs a few
      // dozen built (plus cache extent) to fill the viewport -- if this
      // widget silently materialized a Column of 50,000 children instead
      // of staying on ListView's lazy-building contract, builtCount would
      // equal 50000 here and this assertion would catch it immediately.
      expect(builtCount, lessThan(200));
    });

    testWidgets('renders visible rows with the expected content', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppList(
              itemCount: 5,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 4'), findsOneWidget);
    });

    testWidgets('separates rows with a hairline divider by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppList(
              itemCount: 3,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('cardStyle wraps each row in AppCard with no dividers', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppList(
              itemCount: 3,
              cardStyle: true,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        ),
      );

      expect(find.byType(AppCard), findsNWidgets(3));
      expect(find.byType(Divider), findsNothing);
    });
  });

  group('AppListRow', () {
    testWidgets('tapping calls onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppListRow(
              onTap: () => tapped = true,
              child: const Text('Row'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppListRow));
      expect(tapped, isTrue);
    });

    testWidgets('selected shows primaryContainer fill, unselected has none', (
      tester,
    ) async {
      Future<Color?> fillOf({required bool selected}) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppListRow(selected: selected, child: const Text('x')),
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
    });
  });
}
