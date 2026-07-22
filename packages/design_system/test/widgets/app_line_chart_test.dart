import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLineChart', () {
    testWidgets('renders category labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppLineChart(
              categories: const ['Jan', 'Feb', 'Mar'],
              series: const [
                AppChartSeries(label: 'Value', values: [10, 20, 15]),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Feb'), findsOneWidget);
      expect(find.text('Mar'), findsOneWidget);
    });

    testWidgets('shows a legend only when there is more than one series', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppLineChart(
              categories: const ['Jan', 'Feb'],
              series: const [
                AppChartSeries(label: 'Value', values: [10, 20]),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Value'), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppLineChart(
              categories: const ['Jan', 'Feb'],
              series: const [
                AppChartSeries(label: 'Revenue', values: [10, 20]),
                AppChartSeries(label: 'Cost', values: [5, 8]),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('Cost'), findsOneWidget);
    });

    testWidgets('renders with an empty series list without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppLineChart(categories: ['Jan', 'Feb'], series: []),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders with a single category without dividing by zero', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppLineChart(
              categories: ['Jan'],
              series: [
                AppChartSeries(label: 'Value', values: [10]),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.takeException(), isNull);
    });

    testWidgets('respects disableAnimations -- line appears instantly', (
      tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppLineChart(
              categories: const ['Jan', 'Feb'],
              series: const [
                AppChartSeries(label: 'Value', values: [10, 20]),
              ],
            ),
          ),
        ),
      );
      // A single pump (no settle needed) should already reach final state
      // when the draw-in animation duration collapses to zero.
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
