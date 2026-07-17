import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCard', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppCard(child: Text('content'))),
        ),
      );

      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppCard(onTap: () => tapped = true, child: const Text('x')),
          ),
        ),
      );

      await tester.tap(find.byType(AppCard));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
