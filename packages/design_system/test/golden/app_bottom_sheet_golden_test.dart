import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Same reasoning as `app_dialog_golden_test.dart` — [AppBottomSheet.show]
/// is a static helper around [showModalBottomSheet], has to be opened via
/// a real trigger before there's anything to capture.
Future<void> _openBottomSheet(WidgetTester tester, ThemeData theme) async {
  await tester.binding.setSurfaceSize(const Size(400, 400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => AppBottomSheet.show(
                context,
                builder: (_) => const SizedBox(
                  height: 160,
                  child: Center(child: Text('Sheet content')),
                ),
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
  group('AppBottomSheet.show golden', () {
    testWidgets('light', (tester) async {
      await _openBottomSheet(tester, AppTheme.light());
      await expectLater(
        find.byType(BottomSheet),
        matchesGoldenFile('goldens/app_bottom_sheet_light.png'),
      );
    });

    testWidgets('dark', (tester) async {
      await _openBottomSheet(tester, AppTheme.dark());
      await expectLater(
        find.byType(BottomSheet),
        matchesGoldenFile('goldens/app_bottom_sheet_dark.png'),
      );
    });
  });
}
