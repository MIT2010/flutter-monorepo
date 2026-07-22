import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton', () {
    testWidgets('shows the label and fires onPressed when tapped', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(label: 'Login', onPressed: () => tapped = true),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows a spinner instead of the label while loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(label: 'Login', onPressed: () {}, loading: true),
          ),
        ),
      );

      expect(find.text('Login'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('disables the button while loading', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Login',
              onPressed: () => tapped = true,
              loading: true,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets(
      'stays on the primary-filled surface while loading, not the disabled '
      'palette -- regression test: onPressed:null previously made '
      'ElevatedButton fall back to its disabled fill, leaving the '
      'onPrimary-colored spinner nearly invisible against it',
      (tester) async {
        final theme = AppTheme.light();
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: AppButton(label: 'Login', onPressed: () {}, loading: true),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        final resolvedBackground = button.style!.backgroundColor!.resolve({
          WidgetState.disabled,
        });
        final resolvedForeground = button.style!.foregroundColor!.resolve({
          WidgetState.disabled,
        });

        expect(resolvedBackground, theme.colorScheme.primary);
        expect(resolvedForeground, theme.colorScheme.onPrimary);
      },
    );
  });
}
