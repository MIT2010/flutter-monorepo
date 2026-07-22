import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../utils/format.dart';

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  int _rangeIndex = 2;
  int _selectedInvestment = 0;

  double get _totalValue =>
      MockData.investments.fold(0, (sum, inv) => sum + inv.value);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = MockData.investments[_selectedInvestment];

    return Scaffold(
      appBar: AppBar(title: const Text('Invest')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [
            Text(
              'Portfolio value',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: context.spacing.xxs),
            Text(
              Format.rupiah(_totalValue),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: context.spacing.md),
            AppTabs(
              labels: const ['1D', '1W', '1M', '1Y'],
              initialIndex: _rangeIndex,
              onChanged: (i) => setState(() => _rangeIndex = i),
            ),
            SizedBox(height: context.spacing.md),
            AppCard(
              child: AppLineChart(
                categories: const ['', '', '', '', '', '', '', '', '', ''],
                series: [
                  AppChartSeries(
                    label: selected.symbol,
                    values: selected.history,
                  ),
                ],
                height: 180,
              ),
            ),
            SizedBox(height: context.spacing.xl),
            Text('Holdings', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: context.spacing.xs),
            AppList(
              itemCount: MockData.investments.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                final investment = MockData.investments[i];
                final positive = investment.changePercent >= 0;
                return InkWell(
                  onTap: () => setState(() => _selectedInvestment = i),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing.sm,
                      vertical: context.spacing.xs,
                    ),
                    child: Row(
                      children: [
                        AppAvatar(initials: investment.symbol.substring(0, 2)),
                        SizedBox(width: context.spacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                investment.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: context.spacing.xxxs),
                              Text(
                                '${investment.shares.toStringAsFixed(0)} units',
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
                              Format.rupiah(investment.value),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: context.spacing.xxxs),
                            AppTag(
                              label:
                                  '${positive ? '+' : ''}${investment.changePercent.toStringAsFixed(1)}%',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
