import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTabs', () {
    testWidgets('renders every label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppTabs(labels: ['Overview', 'Details', 'Reviews']),
          ),
        ),
      );

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Reviews'), findsOneWidget);
    });

    testWidgets('starts on initialIndex', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppTabs(
              labels: ['Overview', 'Details', 'Reviews'],
              initialIndex: 1,
            ),
          ),
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller!.index, 1);
    });

    testWidgets('tapping a tab reports its index via onChanged', (
      tester,
    ) async {
      int? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppTabs(
              labels: const ['Overview', 'Details', 'Reviews'],
              onChanged: (i) => selected = i,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Reviews'));
      await tester.pumpAndSettle();

      expect(selected, 2);
    });
  });
}
