import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

void main() {
  group('AppStateView golden', () {
    testWidgets('with action (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 260),
        child: AppStateView(
          icon: Icons.inbox,
          message: 'Belum ada data',
          actionLabel: 'Muat ulang',
          onAction: () {},
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_action_light.png'),
      );
    });

    testWidgets('with action (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 260),
        child: AppStateView(
          icon: Icons.inbox,
          message: 'Belum ada data',
          actionLabel: 'Muat ulang',
          onAction: () {},
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_action_dark.png'),
      );
    });

    testWidgets('without action (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 200),
        child: const AppStateView(
          icon: Icons.search_off,
          message: 'Page not found',
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_no_action_light.png'),
      );
    });

    testWidgets('without action (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 200),
        child: const AppStateView(
          icon: Icons.search_off,
          message: 'Page not found',
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_no_action_dark.png'),
      );
    });

    testWidgets('loading (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 220),
        child: const AppStateView(
          loading: true,
          message: 'Menunggu konfirmasi pembayaran.',
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_loading_light.png'),
      );
    });

    testWidgets('loading (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 220),
        child: const AppStateView(
          loading: true,
          message: 'Menunggu konfirmasi pembayaran.',
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_loading_dark.png'),
      );
    });

    testWidgets('error tone with retry action (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(300, 260),
        child: AppStateView(
          icon: Icons.error_outline,
          message: 'Gagal memuat data',
          tone: AppStateViewTone.error,
          actionLabel: 'Coba lagi',
          onAction: () {},
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_error_light.png'),
      );
    });

    testWidgets('error tone with retry action (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(300, 260),
        child: AppStateView(
          icon: Icons.error_outline,
          message: 'Gagal memuat data',
          tone: AppStateViewTone.error,
          actionLabel: 'Coba lagi',
          onAction: () {},
        ),
      );
      await expectLater(
        find.byType(AppStateView),
        matchesGoldenFile('goldens/app_state_view_error_dark.png'),
      );
    });
  });
}
