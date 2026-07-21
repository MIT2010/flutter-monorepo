import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Closes the one self-acknowledged, unverified gap in
/// docs/VERDANT_DESIGN_SYSTEM.md §14.3: "every Verdant component's
/// dimensions around text must be intrinsic ... verified not to clip text
/// at 200% textScaler" was stated as a rule, not something the six Tahap 2
/// components had actually been checked against. This file is that check.
///
/// A `RenderFlex overflowed` (or any other layout) exception is Flutter's
/// concrete signal that content is being clipped -- caught here via
/// `tester.takeException()` rather than inferred from a screenshot, so a
/// real regression fails the suite instead of shipping unnoticed.
void main() {
  Future<void> pumpAt200Percent(
    WidgetTester tester, {
    required Widget child,
    Size surfaceSize = const Size(400, 800),
  }) async {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2.0)),
          child: child!,
        ),
        home: Scaffold(body: child),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  group('200% textScaler — Tahap 2 components', () {
    testWidgets('AppButton does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: Center(
          child: AppButton(
            label: 'Login with a longer label',
            onPressed: () {},
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppCard does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: const Center(
          child: AppCard(
            child: Text(
              'A card with a realistically long piece of body content '
              'that wraps across multiple lines',
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppTextField does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: AppTextField(label: 'Email address for your account'),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppTextField error state does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: AppTextField(
            label: 'Email',
            errorText: 'Please enter a valid email address to continue',
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppNavigationBar does not overflow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Pumped directly as the Scaffold's bottomNavigationBar, since that's
      // its real usage context (packages/shared's AppShell) -- its fixed
      // SizedBox(height: 64) is the one place in these six components with
      // a hard-coded dimension around text, making it the most likely of
      // the six to actually clip.
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          debugShowCheckedModeBanner: false,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2.0)),
            child: child!,
          ),
          home: Scaffold(
            body: const SizedBox.expand(),
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'AppNavigationBar does not overflow at a narrow small-phone width '
      'with four destinations -- regression test for a real overflow '
      'found and fixed while writing this suite',
      (tester) async {
        // A first, easier adversarial attempt (a 13-character label at
        // 400px/2 destinations, ~200px per cell) did not reproduce an
        // overflow. This harder case -- a small-phone width (320px) with
        // four destinations, ~80px per cell, narrow enough that "Settings"
        // at 200% scale needs two lines -- did: `RenderFlex overflowed by
        // 34 pixels on the bottom`, traced to the fixed-height SizedBox
        // AppNavigationBar's destination cells used to wrap in. Fixed by
        // replacing it with a ConstrainedBox(minHeight: 64) so the bar can
        // grow taller instead of clipping; this test now guards against
        // that regression rather than just having found it once.
        await tester.binding.setSurfaceSize(const Size(320, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2.0)),
              child: child!,
            ),
            home: Scaffold(
              body: const SizedBox.expand(),
              bottomNavigationBar: AppNavigationBar(
                selectedIndex: 0,
                onDestinationSelected: (_) {},
                destinations: const [
                  AppNavigationDestination(icon: Icons.home, label: 'Home'),
                  AppNavigationDestination(
                    icon: Icons.history,
                    label: 'History',
                  ),
                  AppNavigationDestination(
                    icon: Icons.settings,
                    label: 'Settings',
                  ),
                  AppNavigationDestination(
                    icon: Icons.person,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('AppDialog.confirm does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: Builder(
          builder: (context) => AppButton(
            label: 'Open',
            onPressed: () => AppDialog.confirm(
              context,
              title: 'Keluar tanpa menyimpan?',
              message:
                  'Perubahan yang belum disimpan akan hilang secara permanen '
                  'dan tidak dapat dikembalikan lagi setelah ini.',
              confirmLabel: 'Keluar',
              cancelLabel: 'Batal',
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppBottomSheet.show does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: Builder(
          builder: (context) => AppButton(
            label: 'Open',
            onPressed: () => AppBottomSheet.show<void>(
              context,
              builder: (context) => const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sheet content with a longer sentence to see how it '
                  'reflows at double text scale',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppSnackBar.showError does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: Builder(
          builder: (context) => AppButton(
            label: 'Trigger',
            onPressed: () => AppSnackBar.showError(
              context,
              'Gagal menghubungkan ke server, silakan coba lagi nanti',
            ),
          ),
        ),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
    });

    testWidgets('AppStatusBadge does not overflow', (tester) async {
      await pumpAt200Percent(
        tester,
        child: const Center(
          child: AppStatusBadge(
            label: 'Menunggu konfirmasi',
            tone: AppStatusTone.warning,
            icon: Icons.access_time,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
