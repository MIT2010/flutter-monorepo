import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Single series', type: AppBarChart)
Widget appBarChartSingleSeriesUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 320,
      child: AppBarChart(
        categories: ['Jan', 'Feb', 'Mar', 'Apr'],
        series: [
          AppChartSeries(label: 'Revenue', values: [40, 65, 50, 80]),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Multi series', type: AppBarChart)
Widget appBarChartMultiSeriesUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 320,
      child: AppBarChart(
        categories: ['Jan', 'Feb', 'Mar'],
        series: [
          AppChartSeries(label: 'Revenue', values: [40, 65, 50]),
          AppChartSeries(label: 'Cost', values: [20, 30, 25]),
          AppChartSeries(label: 'Profit', values: [20, 35, 25]),
        ],
      ),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. A "Replay" button (not a knob
/// itself) rebuilds this use-case with a new key, letting you watch the
/// once-on-load grow-in animation §10.14 specifies without navigating
/// away and back.
@widgetbook.UseCase(name: 'Interactive', type: AppBarChart)
Widget appBarChartInteractiveUseCase(BuildContext context) {
  final seriesCount = context.knobs.int.slider(
    label: 'Series count (five-color sequence)',
    initialValue: 2,
    min: 1,
    max: 5,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (grow-in)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return Theme(
    data: AppTheme.light(motionSpeedMultiplier: motionSpeedMultiplier),
    child: _ReplayableChart(seriesCount: seriesCount),
  );
}

class _ReplayableChart extends StatefulWidget {
  final int seriesCount;

  const _ReplayableChart({required this.seriesCount});

  @override
  State<_ReplayableChart> createState() => _ReplayableChartState();
}

class _ReplayableChartState extends State<_ReplayableChart> {
  int _replayKey = 0;

  static const _allSeries = [
    AppChartSeries(label: 'Revenue', values: [40, 65, 50, 80]),
    AppChartSeries(label: 'Cost', values: [20, 30, 25, 40]),
    AppChartSeries(label: 'Profit', values: [20, 35, 25, 40]),
    AppChartSeries(label: 'Returns', values: [5, 8, 6, 10]),
    AppChartSeries(label: 'Tax', values: [10, 15, 12, 18]),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 320,
            child: AppBarChart(
              key: ValueKey(_replayKey),
              categories: const ['Jan', 'Feb', 'Mar', 'Apr'],
              series: _allSeries.take(widget.seriesCount).toList(),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _replayKey++),
            child: const Text('Replay grow-in'),
          ),
        ],
      ),
    );
  }
}
