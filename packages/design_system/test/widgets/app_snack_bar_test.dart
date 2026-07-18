import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSnackBar', () {
    testWidgets('showError shows the message tinted with colorScheme.error', (
      tester,
    ) async {
      final theme = AppTheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSnackBar.showError(context, 'Gagal'),
                child: const Text('trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();

      expect(find.text('Gagal'), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, theme.colorScheme.error);
      final text = tester.widget<Text>(find.text('Gagal'));
      expect(text.style?.color, theme.colorScheme.onError);
    });

    testWidgets(
      'showSuccess shows the message tinted with semanticColors.success',
      (tester) async {
        final theme = AppTheme.light();
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => AppSnackBar.showSuccess(context, 'Berhasil'),
                  child: const Text('trigger'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('trigger'));
        await tester.pump();

        expect(find.text('Berhasil'), findsOneWidget);
        final semanticColors = theme.extension<AppSemanticColors>()!;
        final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
        expect(snackBar.backgroundColor, semanticColors.success);
        final text = tester.widget<Text>(find.text('Berhasil'));
        expect(text.style?.color, semanticColors.onSuccess);
      },
    );

    testWidgets('showInfo shows the message with default SnackBar styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => AppSnackBar.showInfo(context, 'Info'),
                child: const Text('trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();

      expect(find.text('Info'), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, isNull);
    });
  });
}
