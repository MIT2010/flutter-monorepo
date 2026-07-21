import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _destinations = [
  AppSidebarDestination(icon: Icons.home_outlined, label: 'Home'),
  AppSidebarDestination(icon: Icons.settings_outlined, label: 'Settings'),
];

void main() {
  group('AppSidebar', () {
    testWidgets('renders every destination icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppSidebar(
              selectedIndex: 0,
              onDestinationSelected: (_) {},
              destinations: _destinations,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('extended shows labels, collapsed fades them out', (
      tester,
    ) async {
      Future<double> opacityOf({required bool extended}) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppSidebar(
                selectedIndex: 0,
                onDestinationSelected: (_) {},
                destinations: _destinations,
                extended: extended,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 250));
        final opacity = tester
            .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
            .first;
        return opacity.opacity;
      }

      expect(await opacityOf(extended: true), 1);
      expect(await opacityOf(extended: false), 0);
    });

    testWidgets('tapping a destination calls onDestinationSelected', (
      tester,
    ) async {
      int? tapped;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppSidebar(
              selectedIndex: 0,
              onDestinationSelected: (i) => tapped = i,
              destinations: _destinations,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Settings'));
      expect(tapped, 1);
    });

    testWidgets(
      'the selected row shows a moss.60 left edge bar, others do not',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppSidebar(
                selectedIndex: 1,
                onDestinationSelected: (_) {},
                destinations: _destinations,
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 250));

        final colorScheme = AppTheme.light().colorScheme;
        final containers = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .toList();
        // First AnimatedContainer is the sidebar panel width animation, the
        // rest are the per-row edge-bar containers.
        final rows = containers.skip(1).toList();

        Color? edgeColorOf(AnimatedContainer c) =>
            ((c.decoration as BoxDecoration).border as Border?)?.left.color;

        expect(edgeColorOf(rows[0]), isNot(colorScheme.primary));
        expect(edgeColorOf(rows[1]), colorScheme.primary);
      },
    );
  });
}
