import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// [AppDialog.confirm] is a static helper around [showDialog], not a
/// widget of its own — it has to actually be opened via a real trigger
/// (not just built in place, the way [pumpGolden] does for the other
/// widgets) before there's anything on screen to capture.
Future<void> _openConfirmDialog(WidgetTester tester, ThemeData theme) async {
  await tester.binding.setSurfaceSize(const Size(400, 300));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => AppDialog.confirm(
                context,
                title: 'Keluar?',
                message: 'Perubahan yang belum disimpan akan hilang.',
                confirmLabel: 'Keluar',
                cancelLabel: 'Batal',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  group('AppDialog.confirm golden', () {
    testWidgets('light', (tester) async {
      await _openConfirmDialog(tester, AppTheme.light());
      await expectLater(
        find.byType(AlertDialog),
        matchesGoldenFile('goldens/app_dialog_confirm_light.png'),
      );
    });

    testWidgets('dark', (tester) async {
      await _openConfirmDialog(tester, AppTheme.dark());
      await expectLater(
        find.byType(AlertDialog),
        matchesGoldenFile('goldens/app_dialog_confirm_dark.png'),
      );
    });
  });
}
