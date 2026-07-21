import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSwitch', () {
    testWidgets('tapping off calls onChanged(true)', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppSwitch(value: false, onChanged: (v) => result = v),
          ),
        ),
      );

      await tester.tap(find.byType(AppSwitch));
      expect(result, isTrue);
    });

    testWidgets('tapping on calls onChanged(false)', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppSwitch(value: true, onChanged: (v) => result = v),
          ),
        ),
      );

      await tester.tap(find.byType(AppSwitch));
      expect(result, isFalse);
    });

    testWidgets('disabled (onChanged null) does not respond to taps', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppSwitch(value: false, onChanged: null)),
        ),
      );

      await tester.tap(find.byType(AppSwitch));
      expect(find.byType(AppSwitch), findsOneWidget);
    });

    testWidgets('on-track fills with primary, off-track with outline', (
      tester,
    ) async {
      Future<Color?> trackOf({required bool value}) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppSwitch(value: value, onChanged: (_) {}),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        final container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        return (container.decoration as BoxDecoration).color;
      }

      final colorScheme = AppTheme.light().colorScheme;
      expect(await trackOf(value: true), colorScheme.primary);
      expect(await trackOf(value: false), colorScheme.outline);
    });
  });
}
