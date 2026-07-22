import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _columns = [
  AppTableColumn(label: 'Name', flex: 2),
  AppTableColumn(label: 'Amount'),
];

void main() {
  group('AppTable', () {
    testWidgets('does not eagerly build every row for a large rowCount', (
      tester,
    ) async {
      var builtCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SizedBox(
              height: 600,
              child: AppTable(
                columns: _columns,
                rowCount: 50000,
                rowBuilder: (context, index) {
                  builtCount++;
                  return [Text('Row $index'), const Text('100')];
                },
              ),
            ),
          ),
        ),
      );

      // Same reasoning as AppList's own test: DataTable-style eager
      // building would make builtCount == 50000 here.
      expect(builtCount, lessThan(200));
    });

    testWidgets('renders header labels and visible row content', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: AppTable(
                columns: _columns,
                rowCount: 3,
                rowBuilder: (context, index) => [
                  Text('Item $index'),
                  const Text('100'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
    });

    testWidgets('tapping a sortable column header calls onSort with its '
        'index', (tester) async {
      int? sorted;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: AppTable(
                columns: _columns,
                rowCount: 3,
                rowBuilder: (context, index) => [
                  Text('Item $index'),
                  const Text('100'),
                ],
                onSort: (i) => sorted = i,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Amount'));
      expect(sorted, 1);
    });

    testWidgets('tapping a row calls onRowTap with its index', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: AppTable(
                columns: _columns,
                rowCount: 3,
                rowBuilder: (context, index) => [
                  Text('Item $index'),
                  const Text('100'),
                ],
                onRowTap: (i) => tapped = i,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Item 1'));
      expect(tapped, 1);
    });

    testWidgets('selected row fills with primaryContainer, no left edge bar '
        '(named §8.2 exception)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SizedBox(
              height: 300,
              child: AppTable(
                columns: _columns,
                rowCount: 3,
                rowBuilder: (context, index) => [
                  Text('Item $index'),
                  const Text('100'),
                ],
                selectedRowIndex: 1,
              ),
            ),
          ),
        ),
      );

      final colorScheme = AppTheme.light().colorScheme;
      // The wash fill is painted by a ColoredBox wrapping each body
      // row's Material -- not by Material.color itself, which is a
      // no-op on a `type: transparency` Material (a real bug this
      // exact assertion caught: it originally checked Material.color
      // and passed even though nothing was actually painted, until the
      // golden's pixels were compared and came back identical to the
      // unselected case).
      final boxes = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
      expect(boxes.any((b) => b.color == colorScheme.primaryContainer), isTrue);
    });
  });
}
