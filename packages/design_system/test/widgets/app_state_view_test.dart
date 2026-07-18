import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStateView', () {
    testWidgets('renders the icon and message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppStateView(icon: Icons.inbox, message: 'Belum ada data'),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('Belum ada data'), findsOneWidget);
    });

    testWidgets('omits the action button when actionLabel/onAction are null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppStateView(icon: Icons.inbox, message: 'Belum ada data'),
          ),
        ),
      );

      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('shows and fires the action button when both are given', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppStateView(
              icon: Icons.inbox,
              message: 'Belum ada data',
              actionLabel: 'Muat ulang',
              onAction: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Muat ulang'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('shows a spinner instead of the icon when loading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppStateView(
              icon: Icons.inbox,
              loading: true,
              message: 'Menunggu konfirmasi...',
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsNothing);
    });

    testWidgets(
      'tints icon and message with colorScheme.error when tone is error',
      (tester) async {
        final theme = AppTheme.light();
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: AppStateView(
                icon: Icons.error_outline,
                message: 'Gagal memuat data',
                tone: AppStateViewTone.error,
              ),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
        expect(icon.color, theme.colorScheme.error);

        final text = tester.widget<Text>(find.text('Gagal memuat data'));
        expect(text.style?.color, theme.colorScheme.error);
      },
    );
  });
}
