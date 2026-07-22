import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

const _columns = [
  AppTableColumn(label: 'Name', flex: 2),
  AppTableColumn(label: 'Amount'),
];

const _rows = [
  ['Sepatu lari', 'Rp150.000'],
  ['Kaos polos', 'Rp75.000'],
  ['Topi', 'Rp50.000'],
];

Widget _table({int? selectedRowIndex}) => AppTable(
  columns: _columns,
  rowCount: _rows.length,
  sortColumnIndex: 1,
  rowBuilder: (context, index) => [
    Text(_rows[index][0]),
    Text(_rows[index][1]),
  ],
  selectedRowIndex: selectedRowIndex,
);

void main() {
  group('AppTable golden', () {
    testWidgets('header + rows, column 1 sorted ascending (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(320, 220),
        child: SizedBox(width: 300, height: 200, child: _table()),
      );
      await expectLater(
        find.byType(AppTable),
        matchesGoldenFile('goldens/app_table_default_light.png'),
      );
    });

    testWidgets('header + rows, column 1 sorted ascending (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(320, 220),
        child: SizedBox(width: 300, height: 200, child: _table()),
      );
      await expectLater(
        find.byType(AppTable),
        matchesGoldenFile('goldens/app_table_default_dark.png'),
      );
    });

    testWidgets(
      'selected row -- wash only, no edge bar (§8.2 exception) (light)',
      (tester) async {
        await pumpGolden(
          tester,
          theme: lightTheme,
          surfaceSize: const Size(320, 220),
          child: SizedBox(
            width: 300,
            height: 200,
            child: _table(selectedRowIndex: 1),
          ),
        );
        await expectLater(
          find.byType(AppTable),
          matchesGoldenFile('goldens/app_table_selected_light.png'),
        );
      },
    );

    testWidgets(
      'selected row -- wash only, no edge bar (§8.2 exception) (dark)',
      (tester) async {
        await pumpGolden(
          tester,
          theme: darkTheme,
          surfaceSize: const Size(320, 220),
          child: SizedBox(
            width: 300,
            height: 200,
            child: _table(selectedRowIndex: 1),
          ),
        );
        await expectLater(
          find.byType(AppTable),
          matchesGoldenFile('goldens/app_table_selected_dark.png'),
        );
      },
    );
  });
}
