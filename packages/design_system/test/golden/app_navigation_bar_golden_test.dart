import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

const _destinations = [
  AppNavigationDestination(icon: Icons.home_outlined, label: 'Home'),
  AppNavigationDestination(icon: Icons.person_outline, label: 'Profile'),
];

void main() {
  group('AppNavigationBar golden', () {
    testWidgets('first destination selected (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(400, 90),
        child: const SizedBox(
          width: 400,
          child: AppNavigationBar(
            selectedIndex: 0,
            onDestinationSelected: _noop,
            destinations: _destinations,
          ),
        ),
      );
      await expectLater(
        find.byType(AppNavigationBar),
        matchesGoldenFile('goldens/app_navigation_bar_default_light.png'),
      );
    });

    testWidgets('first destination selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(400, 90),
        child: const SizedBox(
          width: 400,
          child: AppNavigationBar(
            selectedIndex: 0,
            onDestinationSelected: _noop,
            destinations: _destinations,
          ),
        ),
      );
      await expectLater(
        find.byType(AppNavigationBar),
        matchesGoldenFile('goldens/app_navigation_bar_default_dark.png'),
      );
    });
  });
}

void _noop(int _) {}
