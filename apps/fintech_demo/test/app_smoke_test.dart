import 'package:design_system/design_system.dart';
import 'package:fintech_demo/src/app.dart';
import 'package:fintech_demo/src/pages/bills/bills_page.dart';
import 'package:fintech_demo/src/pages/cards/cards_page.dart';
import 'package:fintech_demo/src/pages/home/home_page.dart';
import 'package:fintech_demo/src/pages/invest/invest_page.dart';
import 'package:fintech_demo/src/pages/notifications/notifications_page.dart';
import 'package:fintech_demo/src/pages/profile/profile_page.dart';
import 'package:fintech_demo/src/pages/transactions/transactions_page.dart';
import 'package:fintech_demo/src/pages/transfer/transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// One test per page confirms it renders against real mock data without
/// throwing -- not full golden coverage (that already exists at the
/// design_system component level; duplicating it per screen here would
/// mostly re-prove design_system's own tests, not this app's wiring).
/// The mock-data plumbing (every model/list in `MockData` actually being
/// consumed by the widget tree) is the thing worth a real regression
/// guard here.
void main() {
  Widget wrap(Widget child) =>
      MaterialApp(theme: AppTheme.light(), home: child);

  group('Page smoke tests -- render against real mock data, no exceptions', () {
    testWidgets('HomePage', (tester) async {
      await tester.pumpWidget(wrap(const HomePage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('Verdant Bank'), findsOneWidget);
    });

    testWidgets('CardsPage', (tester) async {
      await tester.pumpWidget(wrap(const CardsPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('Cards'), findsOneWidget);
    });

    testWidgets('TransferPage', (tester) async {
      await tester.pumpWidget(wrap(const TransferPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('Who are you sending to?'), findsOneWidget);
    });

    testWidgets('BillsPage', (tester) async {
      await tester.pumpWidget(wrap(const BillsPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('Saved billers'), findsOneWidget);
    });

    testWidgets('TransactionsPage settles past the loading state', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TransactionsPage()));
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
      expect(find.byType(AppLoadingIndicator), findsNothing);
    });

    testWidgets('InvestPage', (tester) async {
      await tester.pumpWidget(wrap(const InvestPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('Holdings'), findsOneWidget);
    });

    testWidgets('NotificationsPage', (tester) async {
      await tester.pumpWidget(wrap(const NotificationsPage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('ProfilePage', (tester) async {
      await tester.pumpWidget(wrap(const ProfilePage()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('Aisha Putri'), findsOneWidget);
    });
  });

  group('App navigation', () {
    testWidgets('boots on splash, then reaches onboarding then login', (
      tester,
    ) async {
      await tester.pumpWidget(const VerdantBankApp());
      expect(find.text('Verdant Bank'), findsOneWidget);

      // Splash auto-navigates after 900ms -- pump past that, then let the
      // route transition animation itself settle before asserting.
      await tester.pump(const Duration(milliseconds: 950));
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);

      // Skip straight past onboarding to Login.
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
