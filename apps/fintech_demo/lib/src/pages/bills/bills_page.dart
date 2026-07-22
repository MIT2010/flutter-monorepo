import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  late var _billers = MockData.billers;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
      final sorted = [..._billers];
      if (columnIndex == 0) {
        sorted.sort((a, b) => a.name.compareTo(b.name));
      } else {
        sorted.sort((a, b) => a.category.compareTo(b.category));
      }
      _billers = _sortAscending ? sorted : sorted.reversed.toList();
    });
  }

  void _toggleAutoPay(String billerId) {
    setState(() {
      _billers = [
        for (final biller in _billers)
          if (biller.id == billerId)
            Biller(
              id: biller.id,
              name: biller.name,
              category: biller.category,
              logoInitial: biller.logoInitial,
              savedAccountNumber: biller.savedAccountNumber,
              autoPay: !biller.autoPay,
            )
          else
            biller,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bills')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pay a new bill',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: context.spacing.sm),
              const _NewBillForm(),
              SizedBox(height: context.spacing.xl),
              Text(
                'Saved billers',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: context.spacing.sm),
              // AppTable lays its body out in an Expanded ListView
              // internally (§10.13), so it needs a bounded height from
              // its parent -- this page's own body is a SingleChildScrollView
              // (unbounded height), the same reason every AppTable use in
              // apps/widgetbook is wrapped in a SizedBox too.
              SizedBox(
                height: 56 + (_billers.length * 56),
                child: AppTable(
                  columns: const [
                    AppTableColumn(label: 'Biller', flex: 2),
                    AppTableColumn(label: 'Category'),
                    AppTableColumn(label: 'Auto-pay'),
                  ],
                  rowCount: _billers.length,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  onSort: _sort,
                  rowBuilder: (context, i) {
                    final biller = _billers[i];
                    return [
                      Text(biller.name),
                      Text(biller.category),
                      AppSwitch(
                        value: biller.autoPay,
                        onChanged: (_) => _toggleAutoPay(biller.id),
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewBillForm extends StatefulWidget {
  const _NewBillForm();

  @override
  State<_NewBillForm> createState() => _NewBillFormState();
}

class _NewBillFormState extends State<_NewBillForm> {
  String? _category;
  final _accountController = TextEditingController();
  final _dateController = TextEditingController();
  bool _autoPay = false;

  @override
  void initState() {
    super.initState();
    // Drives the "Pay bill" button's enabled state -- without this the
    // button would only refresh on some *other* unrelated rebuild instead
    // of on every keystroke.
    _accountController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _accountController.removeListener(_refresh);
    _accountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await AppDatePicker.show(
      context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      today: now,
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDropdown<String>(
            label: 'Category',
            value: _category,
            items: [
              for (final category in MockData.billerCategories)
                AppDropdownItem(value: category, label: category),
            ],
            onChanged: (v) => setState(() => _category = v),
          ),
          SizedBox(height: context.spacing.md),
          AppTextField(
            label: 'Customer number',
            controller: _accountController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: context.spacing.md),
          AppTextField(
            label: 'Schedule date',
            readOnly: true,
            controller: _dateController,
            hintText: 'Pay now',
            onTap: _pickDate,
            suffixIcon: VerdantIcon(
              VerdantGlyph.chevronDown,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: context.spacing.sm),
          InkWell(
            onTap: () => setState(() => _autoPay = !_autoPay),
            child: Row(
              children: [
                AppSwitch(
                  value: _autoPay,
                  onChanged: (v) => setState(() => _autoPay = v),
                ),
                SizedBox(width: context.spacing.xs),
                const Expanded(child: Text('Set as auto-pay each month')),
              ],
            ),
          ),
          SizedBox(height: context.spacing.md),
          AppButton(
            label: 'Pay bill',
            onPressed: _category != null && _accountController.text.isNotEmpty
                ? () {
                    AppSnackBar.showSuccess(context, 'Bill payment scheduled');
                    setState(() {
                      _category = null;
                      _accountController.clear();
                      _dateController.clear();
                      _autoPay = false;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
