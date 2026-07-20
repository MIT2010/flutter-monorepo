import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

/// [AppSnackBar] isn't a standalone widget -- it's shown through
/// `ScaffoldMessenger`, so unlike the rest of `test/golden`'s
/// `pumpGolden`-based captures, this pumps a real trigger button and taps
/// it. A bounded 300ms settle (well short of `SnackBar`'s ~4s auto-dismiss
/// timer) captures the fully-entered state without risking
/// `pumpAndSettle` running the virtual clock past the auto-dismiss.
void main() {
  Future<void> showAndCapture(
    WidgetTester tester, {
    required ThemeData theme,
    required VoidCallback Function(BuildContext) trigger,
    required String goldenFile,
  }) async {
    await tester.binding.setSurfaceSize(const Size(400, 200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: trigger(context),
              child: const Text('trigger'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('trigger'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await expectLater(find.byType(SnackBar), matchesGoldenFile(goldenFile));
  }

  group('AppSnackBar golden', () {
    testWidgets('error (light)', (tester) async {
      await showAndCapture(
        tester,
        theme: lightTheme,
        trigger: (context) =>
            () => AppSnackBar.showError(context, 'Gagal'),
        goldenFile: 'goldens/app_snack_bar_error_light.png',
      );
    });

    testWidgets('error (dark)', (tester) async {
      await showAndCapture(
        tester,
        theme: darkTheme,
        trigger: (context) =>
            () => AppSnackBar.showError(context, 'Gagal'),
        goldenFile: 'goldens/app_snack_bar_error_dark.png',
      );
    });

    testWidgets('success (light)', (tester) async {
      await showAndCapture(
        tester,
        theme: lightTheme,
        trigger: (context) =>
            () => AppSnackBar.showSuccess(context, 'Berhasil'),
        goldenFile: 'goldens/app_snack_bar_success_light.png',
      );
    });

    testWidgets('success (dark)', (tester) async {
      await showAndCapture(
        tester,
        theme: darkTheme,
        trigger: (context) =>
            () => AppSnackBar.showSuccess(context, 'Berhasil'),
        goldenFile: 'goldens/app_snack_bar_success_dark.png',
      );
    });

    testWidgets('info (light)', (tester) async {
      await showAndCapture(
        tester,
        theme: lightTheme,
        trigger: (context) =>
            () => AppSnackBar.showInfo(context, 'Info'),
        goldenFile: 'goldens/app_snack_bar_info_light.png',
      );
    });

    testWidgets('info (dark)', (tester) async {
      await showAndCapture(
        tester,
        theme: darkTheme,
        trigger: (context) =>
            () => AppSnackBar.showInfo(context, 'Info'),
        goldenFile: 'goldens/app_snack_bar_info_dark.png',
      );
    });
  });
}
