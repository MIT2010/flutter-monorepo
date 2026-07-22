import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// One data series in an [AppBarChart] — a label (for the legend) plus
/// one value per category, aligned by index with the chart's
/// `categories` list.
class AppChartSeries {
  final String label;
  final List<double> values;

  const AppChartSeries({required this.label, required this.values});
}

/// Data communication, not decoration (§10.14) — the single highest-risk
/// component in this system for accidentally introducing saturated,
/// rainbow color where restraint should dominate.
///
/// **Color**: multi-series bars cycle through `context.semanticColors.
/// chartSeries` — the exact `moss.60`/`mist.60`/`brass.60`/`ember.60`/
/// `stone.60` five-series order §10.14 names, added to
/// [AppSemanticColors] rather than referenced as raw [VerdantColors]
/// here (component code never reaches for `VerdantColors` directly —
/// only `AppTheme`'s own token-construction layer does).
///
/// **Performance is part of this spec, not an afterthought**: bars are
/// drawn with a single [CustomPainter] pass over a [Canvas], not one
/// [Widget] per bar. A chart is normally an *aggregated* view (tens of
/// bars, not thousands of raw rows the way [AppList]/[AppTable] can be),
/// but per-widget overhead still isn't free, and a canvas draw call
/// scales the same whether there are 5 bars or 500.
///
/// **Motion**: bars grow in once via `motion.standard` + Verdant Enter
/// on first load — never replayed on rebuild, never a looping "live
/// data" pulse. Respects `MediaQuery.disableAnimations` (§8.7): bars
/// simply appear at final height instead of animating.
///
/// **Disclosed scope gap**: only a bar chart ships in this pass. §10.14
/// also describes a line-drawing entrance ("a line drawing left-to-right")
/// as part of the *general* chart motion language, not a mandate that a
/// line-chart variant ships alongside the bar chart in the same batch —
/// this widget covers the one explicitly, concretely spec'd shape
/// ("bars rising").
@verdantPreview
class AppBarChart extends StatefulWidget {
  final List<String> categories;
  final List<AppChartSeries> series;
  final double height;

  const AppBarChart({
    super.key,
    required this.categories,
    required this.series,
    this.height = 240,
  });

  @override
  State<AppBarChart> createState() => _AppBarChartState();
}

class _AppBarChartState extends State<AppBarChart>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _growth;

  // Same reason as AppTabs' TabController: `context.motion` reads
  // Theme.of(context), which can't be called from initState.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final motion = context.motion;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final controller = AnimationController(
      vsync: this,
      duration: reduceMotion ? Duration.zero : motion.durationStandard,
    );
    _controller = controller;
    _growth = CurvedAnimation(parent: controller, curve: motion.curveEnter);
    controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = context.semanticColors.chartSeries;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.series.length > 1) ...[
          _Legend(series: widget.series, colors: colors),
          SizedBox(height: context.spacing.sm),
        ],
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _growth ?? const AlwaysStoppedAnimation(1),
            builder: (context, _) => CustomPaint(
              painter: _BarChartPainter(
                categories: widget.categories,
                series: widget.series,
                growth: _growth?.value ?? 1,
                colors: colors,
                axisColor: colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
        SizedBox(height: context.spacing.xxs),
        _CategoryLabels(categories: widget.categories),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final List<AppChartSeries> series;
  final List<Color> colors;

  const _Legend({required this.series, required this.colors});

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Wrap(
      spacing: context.spacing.sm,
      runSpacing: context.spacing.xxs,
      children: [
        for (var i = 0; i < series.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                color: colors[i % colors.length],
              ),
              SizedBox(width: context.spacing.xxxs),
              Text(
                series[i].label,
                style: TextStyle(fontSize: 12, color: onSurfaceVariant),
              ),
            ],
          ),
      ],
    );
  }
}

class _CategoryLabels extends StatelessWidget {
  final List<String> categories;

  const _CategoryLabels({required this.categories});

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        for (final category in categories)
          Expanded(
            child: Center(
              child: Text(
                category,
                style: TextStyle(fontSize: 12, color: onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<String> categories;
  final List<AppChartSeries> series;
  final double growth;
  final List<Color> colors;
  final Color axisColor;

  _BarChartPainter({
    required this.categories,
    required this.series,
    required this.growth,
    required this.colors,
    required this.axisColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      Paint()
        ..color = axisColor
        ..strokeWidth = 1,
    );

    if (categories.isEmpty || series.isEmpty) return;
    final maxValue = series
        .expand((s) => s.values)
        .fold<double>(0, (max, v) => v > max ? v : max);
    if (maxValue <= 0) return;

    final groupCount = categories.length;
    final groupWidth = size.width / groupCount;
    final barsPerGroup = series.length;
    final slotWidth = groupWidth / barsPerGroup;
    final slotPadding = slotWidth * 0.15;
    final barWidth = slotWidth - slotPadding * 2;

    for (var g = 0; g < groupCount; g++) {
      for (var s = 0; s < barsPerGroup; s++) {
        final values = series[s].values;
        final value = g < values.length ? values[g] : 0.0;
        final barHeight = (value / maxValue) * size.height * growth;
        final left = g * groupWidth + s * slotWidth + slotPadding;
        canvas.drawRect(
          Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
          Paint()..color = colors[s % colors.length],
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.growth != growth ||
        oldDelegate.categories != categories ||
        oldDelegate.series != series ||
        oldDelegate.colors != colors;
  }
}
