import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';
import 'app_bar_chart.dart' show AppChartSeries;

/// Data communication, not decoration (§10.14) — the trend counterpart to
/// [AppBarChart], for the shape [AppBarChart]'s own doc comment disclosed
/// as out of scope: "a line drawing left-to-right" as an entrance, and a
/// continuous trend (spending over time, portfolio value) rather than
/// discrete comparable categories.
///
/// **Color**: same `context.semanticColors.chartSeries` cycle
/// [AppBarChart] uses, for the same reason — one shared, already-audited
/// palette rather than a second one invented here.
///
/// **[filled]** draws a soft, flat (never gradient — §1's restraint,
/// §12's anti-pattern pass already rules out decorative gradients
/// elsewhere in this system) fill under the line at 12% opacity of the
/// line's own color. Only applied when there's exactly one series —
/// stacking translucent fills under multiple overlapping lines reads as
/// visual noise, not signal, so a multi-series chart stays line-only
/// regardless of this flag.
///
/// **Performance**: one [CustomPainter] pass, same reasoning as
/// [AppBarChart] — a chart is an aggregated view, not a raw per-row list.
///
/// **Motion**: the line draws in left-to-right via `motion.standard` +
/// Enter — an animated `Path` extraction along the line's own
/// length, not a generic fade/scale, since a trend line's own shape *is*
/// the thing worth animating. Respects `MediaQuery.disableAnimations`
/// (§8.7): the full line simply appears with no animation.
class AppLineChart extends StatefulWidget {
  final List<String> categories;
  final List<AppChartSeries> series;
  final double height;
  final bool filled;

  const AppLineChart({
    super.key,
    required this.categories,
    required this.series,
    this.height = 240,
    this.filled = true,
  });

  @override
  State<AppLineChart> createState() => _AppLineChartState();
}

class _AppLineChartState extends State<AppLineChart>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _growth;

  // Same reason as AppBarChart's own controller: `context.motion` reads
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
          _LineLegend(series: widget.series, colors: colors),
          SizedBox(height: context.spacing.sm),
        ],
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _growth ?? const AlwaysStoppedAnimation(1),
            builder: (context, _) => CustomPaint(
              painter: _LineChartPainter(
                categories: widget.categories,
                series: widget.series,
                growth: _growth?.value ?? 1,
                colors: colors,
                axisColor: colorScheme.outlineVariant,
                filled: widget.filled && widget.series.length == 1,
              ),
            ),
          ),
        ),
        SizedBox(height: context.spacing.xxs),
        _LineCategoryLabels(categories: widget.categories),
      ],
    );
  }
}

class _LineLegend extends StatelessWidget {
  final List<AppChartSeries> series;
  final List<Color> colors;

  const _LineLegend({required this.series, required this.colors});

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
              Container(width: 10, height: 2, color: colors[i % colors.length]),
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

class _LineCategoryLabels extends StatelessWidget {
  final List<String> categories;

  const _LineCategoryLabels({required this.categories});

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

class _LineChartPainter extends CustomPainter {
  final List<String> categories;
  final List<AppChartSeries> series;
  final double growth;
  final List<Color> colors;
  final Color axisColor;
  final bool filled;

  _LineChartPainter({
    required this.categories,
    required this.series,
    required this.growth,
    required this.colors,
    required this.axisColor,
    required this.filled,
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

    if (categories.isEmpty || series.isEmpty || growth <= 0) return;
    final maxValue = series
        .expand((s) => s.values)
        .fold<double>(0, (max, v) => v > max ? v : max);
    final minValue = series
        .expand((s) => s.values)
        .fold<double>(maxValue, (min, v) => v < min ? v : min);
    final range = (maxValue - minValue) <= 0 ? 1 : maxValue - minValue;

    final pointCount = categories.length;
    // A single category has no line to draw -- fall back to a flat dot
    // at its own value rather than dividing by (pointCount - 1) == 0.
    final stepX = pointCount > 1 ? size.width / (pointCount - 1) : 0.0;

    Offset pointFor(List<double> values, int index) {
      final value = index < values.length ? values[index] : minValue;
      final normalized = (value - minValue) / range;
      return Offset(index * stepX, size.height - normalized * size.height);
    }

    for (var s = 0; s < series.length; s++) {
      final values = series[s].values;
      final color = colors[s % colors.length];
      final fullPath = Path();
      for (var i = 0; i < pointCount; i++) {
        final point = pointFor(values, i);
        if (i == 0) {
          fullPath.moveTo(point.dx, point.dy);
        } else {
          fullPath.lineTo(point.dx, point.dy);
        }
      }

      final metrics = fullPath.computeMetrics().toList();
      final totalLength = metrics.fold<double>(0, (sum, m) => sum + m.length);
      final revealLength = totalLength * growth;
      final revealPath = Path();
      var consumed = 0.0;
      for (final metric in metrics) {
        if (consumed >= revealLength) break;
        final remaining = revealLength - consumed;
        final extractLength = remaining < metric.length
            ? remaining
            : metric.length;
        revealPath.addPath(metric.extractPath(0, extractLength), Offset.zero);
        consumed += metric.length;
      }

      if (filled) {
        final fillPath = Path.from(revealPath)
          ..lineTo(
            pointCount > 1 ? (revealLength / totalLength) * size.width : 0,
            size.height,
          )
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(
          fillPath,
          Paint()..color = color.withValues(alpha: 0.12),
        );
      }

      canvas.drawPath(
        revealPath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.growth != growth ||
        oldDelegate.categories != categories ||
        oldDelegate.series != series ||
        oldDelegate.colors != colors ||
        oldDelegate.filled != filled;
  }
}
