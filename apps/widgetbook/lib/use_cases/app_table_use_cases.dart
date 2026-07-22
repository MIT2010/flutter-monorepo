import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

const _columns = [
  AppTableColumn(label: 'Name', flex: 2),
  AppTableColumn(label: 'Amount'),
];

const _rows = [
  ['Sepatu lari', 'Rp150.000'],
  ['Kaos polos', 'Rp75.000'],
  ['Topi', 'Rp50.000'],
];

@widgetbook.UseCase(name: 'Default', type: AppTable)
Widget appTableDefaultUseCase(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 220,
    child: AppTable(
      columns: _columns,
      rowCount: _rows.length,
      sortColumnIndex: 1,
      rowBuilder: (context, index) => [
        Text(_rows[index][0]),
        Text(_rows[index][1]),
      ],
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. `rowCount` is knob-driven up to
/// 5,000 for the same "virtualized, not DataTable" reason as AppList's
/// own interactive use-case.
@widgetbook.UseCase(name: 'Interactive', type: AppTable)
Widget appTableInteractiveUseCase(BuildContext context) {
  final rowCount = context.knobs.int.slider(
    label: 'Row count (virtualized -- try a large number)',
    initialValue: 20,
    min: 3,
    max: 5000,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — sort arrow, selected-row wash)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );

  return Theme(
    data: AppTheme.light(primaryColor: primaryColor),
    child: SizedBox(
      width: 320,
      height: 320,
      child: _InteractiveTable(rowCount: rowCount),
    ),
  );
}

class _InteractiveTable extends StatefulWidget {
  final int rowCount;

  const _InteractiveTable({required this.rowCount});

  @override
  State<_InteractiveTable> createState() => _InteractiveTableState();
}

class _InteractiveTableState extends State<_InteractiveTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return AppTable(
      columns: _columns,
      rowCount: widget.rowCount,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      onSort: (i) => setState(() {
        if (_sortColumnIndex == i) {
          _sortAscending = !_sortAscending;
        } else {
          _sortColumnIndex = i;
          _sortAscending = true;
        }
      }),
      selectedRowIndex: _selected,
      onRowTap: (i) => setState(() => _selected = i),
      rowBuilder: (context, index) => [
        Text('Row $index'),
        Text('Rp${(index + 1) * 1000}'),
      ],
    );
  }
}
