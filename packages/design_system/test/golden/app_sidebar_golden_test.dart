import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

const _destinations = [
  AppSidebarDestination(icon: Icons.home_outlined, label: 'Home'),
  AppSidebarDestination(icon: Icons.inbox_outlined, label: 'Inbox'),
  AppSidebarDestination(icon: Icons.settings_outlined, label: 'Settings'),
];

void main() {
  group('AppSidebar golden', () {
    testWidgets('extended, second destination selected (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(280, 200),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 200,
            child: AppSidebar(
              selectedIndex: 1,
              onDestinationSelected: (_) {},
              destinations: _destinations,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(AppSidebar),
        matchesGoldenFile('goldens/app_sidebar_extended_light.png'),
      );
    });

    testWidgets('extended, second destination selected (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(280, 200),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 200,
            child: AppSidebar(
              selectedIndex: 1,
              onDestinationSelected: (_) {},
              destinations: _destinations,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(AppSidebar),
        matchesGoldenFile('goldens/app_sidebar_extended_dark.png'),
      );
    });

    testWidgets('collapsed, second destination selected (light)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(120, 200),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 200,
            child: AppSidebar(
              selectedIndex: 1,
              onDestinationSelected: (_) {},
              destinations: _destinations,
              extended: false,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(AppSidebar),
        matchesGoldenFile('goldens/app_sidebar_collapsed_light.png'),
      );
    });

    testWidgets('collapsed, second destination selected (dark)', (
      tester,
    ) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(120, 200),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 200,
            child: AppSidebar(
              selectedIndex: 1,
              onDestinationSelected: (_) {},
              destinations: _destinations,
              extended: false,
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(AppSidebar),
        matchesGoldenFile('goldens/app_sidebar_collapsed_dark.png'),
      );
    });
  });
}
