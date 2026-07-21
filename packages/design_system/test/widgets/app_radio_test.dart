import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRadio', () {
    testWidgets('tapping an unselected radio calls onChanged with its value', (
      tester,
    ) async {
      int? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppRadio<int>(
              value: 2,
              groupValue: 1,
              onChanged: (v) => result = v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppRadio<int>));
      expect(result, 2);
    });

    testWidgets('disabled (onChanged null) does not respond to taps', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppRadio<int>(value: 1, groupValue: 0, onChanged: null),
          ),
        ),
      );

      await tester.tap(find.byType(AppRadio<int>));
      expect(find.byType(AppRadio<int>), findsOneWidget);
    });

    testWidgets('a group of radios only lets one be selected at a time', (
      tester,
    ) async {
      int selected = 0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: Column(
                children: [
                  AppRadio<int>(
                    value: 0,
                    groupValue: selected,
                    onChanged: (v) => setState(() => selected = v!),
                  ),
                  AppRadio<int>(
                    value: 1,
                    groupValue: selected,
                    onChanged: (v) => setState(() => selected = v!),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppRadio<int>).at(1));
      await tester.pump();
      expect(selected, 1);

      await tester.tap(find.byType(AppRadio<int>).at(0));
      await tester.pump();
      expect(selected, 0);
    });
  });
}
