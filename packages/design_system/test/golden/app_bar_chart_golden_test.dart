import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppBarChart golden', () {
    testWidgets('single series, settled after grow-in (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(340, 300),
        child: const SizedBox(
          width: 320,
          child: AppBarChart(
            categories: ['Jan', 'Feb', 'Mar', 'Apr'],
            series: [
              AppChartSeries(label: 'Revenue', values: [40, 65, 50, 80]),
            ],
          ),
        ),
      );
      // The grow-in animation runs motion.standard (220ms) -- the
      // harness's default settle window isn't long enough on its own, so
      // this extra pump is what actually reaches the final bar heights
      // rather than an arbitrary mid-animation frame.
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppBarChart),
        matchesGoldenFile('goldens/app_bar_chart_single_series_light.png'),
      );
    });

    testWidgets('single series, settled after grow-in (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(340, 300),
        child: const SizedBox(
          width: 320,
          child: AppBarChart(
            categories: ['Jan', 'Feb', 'Mar', 'Apr'],
            series: [
              AppChartSeries(label: 'Revenue', values: [40, 65, 50, 80]),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppBarChart),
        matchesGoldenFile('goldens/app_bar_chart_single_series_dark.png'),
      );
    });

    testWidgets('multi-series with legend, five-color sequence (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(340, 320),
        child: const SizedBox(
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
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppBarChart),
        matchesGoldenFile('goldens/app_bar_chart_multi_series_light.png'),
      );
    });

    testWidgets('multi-series with legend, five-color sequence (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(340, 320),
        child: const SizedBox(
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
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(AppBarChart),
        matchesGoldenFile('goldens/app_bar_chart_multi_series_dark.png'),
      );
    });
  });
}
