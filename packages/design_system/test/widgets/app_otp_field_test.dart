import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppOtpField', () {
    testWidgets('typing a digit auto-advances focus to the next cell', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppOtpField(length: 4)),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.pump();

      final cell1 = tester.widget<TextField>(find.byType(TextField).at(1));
      expect(cell1.focusNode!.hasFocus, isTrue);
    });

    testWidgets('does not advance past the last cell', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppOtpField(length: 4)),
        ),
      );

      final lastField = tester.widget<TextField>(find.byType(TextField).last);
      lastField.focusNode!.requestFocus();
      await tester.pump();

      await tester.enterText(find.byType(TextField).last, '9');
      await tester.pump();

      // No exception, no 5th cell to move to -- focus simply stays put.
      expect(find.byType(TextField), findsNWidgets(4));
    });

    testWidgets('onChanged reports the concatenated code as cells fill', (
      tester,
    ) async {
      final codes = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: AppOtpField(length: 3, onChanged: codes.add)),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.pump();

      expect(codes.last, '123');
    });

    testWidgets('onCompleted fires once the last cell is filled', (
      tester,
    ) async {
      String? completed;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AppOtpField(
              length: 3,
              onCompleted: (code) => completed = code,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.pump();
      expect(completed, isNull);

      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.pump();
      expect(completed, '123');
    });

    testWidgets('backspace on an already-empty cell clears and refocuses the '
        'previous cell', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppOtpField(length: 4)),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.pump();
      // Focus auto-advanced to cell 1, which is empty.
      final cell1 = tester.widget<TextField>(find.byType(TextField).at(1));
      expect(cell1.focusNode!.hasFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();

      final cell0 = tester.widget<TextField>(find.byType(TextField).at(0));
      expect(cell0.focusNode!.hasFocus, isTrue);
      expect(cell0.controller!.text, isEmpty);
    });

    testWidgets('backspace on the first cell (already empty) is a no-op', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppOtpField(length: 4)),
        ),
      );

      final cell0 = tester.widget<TextField>(find.byType(TextField).first);
      cell0.focusNode!.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();

      // No exception thrown reaching for a nonexistent -1 index.
      expect(find.byType(TextField), findsNWidgets(4));
    });

    testWidgets('non-digit input is filtered out', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppOtpField(length: 4)),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'a');
      await tester.pump();

      final cell0 = tester.widget<TextField>(find.byType(TextField).at(0));
      expect(cell0.controller!.text, isEmpty);
    });

    testWidgets('errorText renders as shared helper text below the cells', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppOtpField(length: 4, errorText: 'Kode salah'),
          ),
        ),
      );

      expect(find.text('Kode salah'), findsOneWidget);
    });
  });
}
