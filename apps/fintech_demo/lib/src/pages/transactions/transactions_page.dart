import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../utils/format.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool _loading = true;
  int _tabIndex = 0;
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> get _filtered {
    var list = MockData.transactions;
    if (_tabIndex == 1) {
      list = list
          .where((t) => t.direction == TransactionDirection.credit)
          .toList();
    } else if (_tabIndex == 2) {
      list = list
          .where((t) => t.direction == TransactionDirection.debit)
          .toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((t) => t.title.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSearchField(
                controller: _searchController,
                hintText: 'Search transactions',
                onChanged: (v) => setState(() => _query = v),
              ),
              SizedBox(height: context.spacing.sm),
              AppTabs(
                labels: const ['All', 'Income', 'Expense'],
                onChanged: (i) => setState(() => _tabIndex = i),
              ),
              SizedBox(height: context.spacing.sm),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const AppLoadingIndicator();
    }
    final items = _filtered;
    if (items.isEmpty) {
      return AppStateView(
        message: _query.isEmpty
            ? 'No transactions in this category yet'
            : 'No transactions match "$_query"',
        icon: Icons.receipt_long_outlined,
      );
    }

    return AppList(
      itemCount: items.length,
      cardStyle: true,
      itemBuilder: (context, i) => _HistoryRow(transaction: items[i]),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final Transaction transaction;

  const _HistoryRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final credit = transaction.direction == TransactionDirection.credit;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.sm,
        vertical: context.spacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, overflow: TextOverflow.ellipsis),
                SizedBox(height: context.spacing.xxxs),
                Text(
                  Format.dateTime(transaction.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${credit ? '+' : '-'}${Format.rupiah(transaction.amount)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: credit ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
              SizedBox(height: context.spacing.xxxs),
              if (transaction.status == TransactionStatus.pending)
                const AppStatusBadge(
                  label: 'Pending',
                  tone: AppStatusTone.warning,
                )
              else if (transaction.status == TransactionStatus.failed)
                Text(
                  'Failed',
                  style: TextStyle(color: colorScheme.error, fontSize: 12),
                )
              else
                const AppStatusBadge(
                  label: 'Success',
                  tone: AppStatusTone.success,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
