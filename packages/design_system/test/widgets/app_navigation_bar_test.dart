import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppNavigationBar', () {
    testWidgets('shows every destination label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            bottomNavigationBar: AppNavigationBar(
              selectedIndex: 0,
              onDestinationSelected: (_) {},
              destinations: const [
                AppNavigationDestination(icon: Icons.home, label: 'Home'),
                AppNavigationDestination(icon: Icons.person, label: 'Profile'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('reports the tapped destination index', (tester) async {
      int? selected;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            bottomNavigationBar: AppNavigationBar(
              selectedIndex: 0,
              onDestinationSelected: (index) => selected = index,
              destinations: const [
                AppNavigationDestination(icon: Icons.home, label: 'Home'),
                AppNavigationDestination(icon: Icons.person, label: 'Profile'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Profile'));
      await tester.pump();

      expect(selected, 1);
    });
  });
}
