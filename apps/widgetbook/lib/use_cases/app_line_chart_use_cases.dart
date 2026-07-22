import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Single series, filled', type: AppLineChart)
Widget appLineChartSingleSeriesUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 320,
      child: AppLineChart(
        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
        series: [
          AppChartSeries(label: 'Value', values: [40, 65, 50, 80, 70]),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Multi series, no fill', type: AppLineChart)
Widget appLineChartMultiSeriesUseCase(BuildContext context) {
  return const Center(
    child: SizedBox(
      width: 320,
      child: AppLineChart(
        categories: ['Jan', 'Feb', 'Mar', 'Apr'],
        series: [
          AppChartSeries(label: 'Revenue', values: [40, 65, 50, 80]),
          AppChartSeries(label: 'Cost', values: [20, 30, 25, 40]),
        ],
      ),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. A "Replay" button (not a knob
/// itself) rebuilds this use-case with a new key, letting you watch the
/// once-on-load draw-in animation without navigating away and back.
@widgetbook.UseCase(name: 'Interactive', type: AppLineChart)
Widget appLineChartInteractiveUseCase(BuildContext context) {
  final seriesCount = context.knobs.int.slider(
    label: 'Series count (five-color sequence)',
    initialValue: 1,
    min: 1,
    max: 5,
  );
  final filled = context.knobs.boolean(
    label: 'Filled (single series only)',
    initialValue: true,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (draw-in)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return Theme(
    data: AppTheme.light(motionSpeedMultiplier: motionSpeedMultiplier),
    child: _ReplayableLineChart(seriesCount: seriesCount, filled: filled),
  );
}

class _ReplayableLineChart extends StatefulWidget {
  final int seriesCount;
  final bool filled;

  const _ReplayableLineChart({required this.seriesCount, required this.filled});

  @override
  State<_ReplayableLineChart> createState() => _ReplayableLineChartState();
}

class _ReplayableLineChartState extends State<_ReplayableLineChart> {
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
            child: AppLineChart(
              key: ValueKey(_replayKey),
              categories: const ['Jan', 'Feb', 'Mar', 'Apr'],
              series: _allSeries.take(widget.seriesCount).toList(),
              filled: widget.filled,
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _replayKey++),
            child: const Text('Replay draw-in'),
          ),
        ],
      ),
    );
  }
}
