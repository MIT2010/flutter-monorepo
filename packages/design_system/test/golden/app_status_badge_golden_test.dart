import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppStatusBadge golden', () {
    testWidgets('success (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: const AppStatusBadge(
          label: 'Selesai',
          tone: AppStatusTone.success,
          icon: Icons.check,
        ),
      );
      await expectLater(
        find.byType(AppStatusBadge),
        matchesGoldenFile('goldens/app_status_badge_success_light.png'),
      );
    });

    testWidgets('success (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: const AppStatusBadge(
          label: 'Selesai',
          tone: AppStatusTone.success,
          icon: Icons.check,
        ),
      );
      await expectLater(
        find.byType(AppStatusBadge),
        matchesGoldenFile('goldens/app_status_badge_success_dark.png'),
      );
    });

    testWidgets('warning (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: const AppStatusBadge(
          label: 'Perhatian',
          tone: AppStatusTone.warning,
        ),
      );
      await expectLater(
        find.byType(AppStatusBadge),
        matchesGoldenFile('goldens/app_status_badge_warning_light.png'),
      );
    });

    testWidgets('warning (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: const AppStatusBadge(
          label: 'Perhatian',
          tone: AppStatusTone.warning,
        ),
      );
      await expectLater(
        find.byType(AppStatusBadge),
        matchesGoldenFile('goldens/app_status_badge_warning_dark.png'),
      );
    });

    testWidgets('info (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: const AppStatusBadge(label: 'Info', tone: AppStatusTone.info),
      );
      await expectLater(
        find.byType(AppStatusBadge),
        matchesGoldenFile('goldens/app_status_badge_info_light.png'),
      );
    });

    testWidgets('info (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: const AppStatusBadge(label: 'Info', tone: AppStatusTone.info),
      );
      await expectLater(
        find.byType(AppStatusBadge),
        matchesGoldenFile('goldens/app_status_badge_info_dark.png'),
      );
    });
  });
}
