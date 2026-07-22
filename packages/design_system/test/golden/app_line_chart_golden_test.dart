import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppLineChart golden', () {
    testWidgets('single series, filled, settled after draw-in (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(340, 300),
        child: const SizedBox(
          width: 320,
          child: AppLineChart(
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
            series: [
              AppChartSeries(label: 'Value', values: [40, 65, 50, 80, 70]),
            ],
          ),
        ),
      );
      // The draw-in animation runs motion.standard (220ms) -- the
      // harness's default settle window isn't long enough on its own, so
      // this extra pump is what actually reaches the full line rather
      // than an arbitrary mid-animation frame.
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppLineChart),
        matchesGoldenFile('goldens/app_line_chart_single_series_light.png'),
      );
    });

    testWidgets('single series, filled, settled after draw-in (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(340, 300),
        child: const SizedBox(
          width: 320,
          child: AppLineChart(
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
            series: [
              AppChartSeries(label: 'Value', values: [40, 65, 50, 80, 70]),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppLineChart),
        matchesGoldenFile('goldens/app_line_chart_single_series_dark.png'),
      );
    });

    testWidgets('multi-series with legend, no fill (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(340, 320),
        child: const SizedBox(
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
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppLineChart),
        matchesGoldenFile('goldens/app_line_chart_multi_series_light.png'),
      );
    });

    testWidgets('multi-series with legend, no fill (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(340, 320),
        child: const SizedBox(
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
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppLineChart),
        matchesGoldenFile('goldens/app_line_chart_multi_series_dark.png'),
      );
    });
  });
}
