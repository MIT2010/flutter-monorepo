import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../router/routes.dart';
import '../../utils/format.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final recent = MockData.transactions.take(4).toList();
    final unreadCount = MockData.notifications.where((n) => !n.read).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verdant Bank'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.push(Routes.notifications),
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: Icon(
                Icons.notifications_outlined,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [
            _BalanceCard(account: MockData.account),
            SizedBox(height: context.spacing.lg),
            _QuickActions(),
            SizedBox(height: context.spacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spending this week',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AppTooltip(
                  message: 'Sum of all debit transactions per weekday',
                  child: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.sm),
            AppCard(
              child: const AppBarChart(
                categories: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                series: [
                  AppChartSeries(
                    label: 'Spending',
                    values: [
                      120000,
                      340000,
                      90000,
                      410000,
                      220000,
                      580000,
                      260000,
                    ],
                  ),
                ],
                height: 160,
              ),
            ),
            SizedBox(height: context.spacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent transactions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => context.push(Routes.transactions),
                  child: const Text('See all'),
                ),
              ],
            ),
            SizedBox(height: context.spacing.xs),
            AppList(
              itemCount: recent.length,
              cardStyle: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) =>
                  _TransactionRow(transaction: recent[i]),
            ),
          ],
        ),
      ),
    );
  }
}

/// A filled hero treatment, not [AppExpressiveCard]'s bordered/quiet
/// register (§5.4) -- the account balance is this page's single most
/// important number and reads better with real visual weight than a
/// hairline-bordered box indistinguishable from every other resting
/// surface on the page. Solid `colorScheme.primary` fill, no gradient
/// (§5.4's anti-pattern ruling), no shadow (§6 -- still page content, not
/// a floating surface) -- the same treatment `AppPaymentCard` (§10.26)
/// uses for the same reason.
class _BalanceCard extends StatelessWidget {
  final BankAccount account;

  const _BalanceCard({required this.account});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(context.shape.radiusSm),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${account.name} ${account.maskedNumber}',
              style: TextStyle(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: context.spacing.xxs),
            Text(
              Format.rupiah(account.balance),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actions = [
      (Icons.arrow_upward, 'Transfer', Routes.transfer),
      (Icons.receipt_long_outlined, 'Bills', Routes.bills),
      (Icons.trending_up, 'Invest', Routes.invest),
      (Icons.credit_card, 'Cards', Routes.cards),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final action in actions)
          InkWell(
            onTap: () => context.push(action.$3),
            borderRadius: BorderRadius.circular(context.shape.radiusSm),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.spacing.xs),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primaryContainer,
                    ),
                    child: Icon(
                      action.$1,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  SizedBox(height: context.spacing.xxs),
                  Text(action.$2, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const _TransactionRow({required this.transaction});

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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHigh,
            ),
            child: Icon(
              credit ? Icons.call_received : Icons.call_made,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: context.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, overflow: TextOverflow.ellipsis),
                SizedBox(height: context.spacing.xxxs),
                Row(
                  children: [
                    AppTag(label: transaction.category),
                    if (transaction.status != TransactionStatus.success) ...[
                      SizedBox(width: context.spacing.xxs),
                      AppStatusBadge(
                        label: transaction.status == TransactionStatus.pending
                            ? 'Pending'
                            : 'Failed',
                        tone: AppStatusTone.warning,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${credit ? '+' : '-'}${Format.rupiah(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: credit ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
