import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppThemeContext', () {
    testWidgets('context.spacing resolves the registered extension', (
      tester,
    ) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(capturedContext.spacing.md, AppSpacingExtension.standard.md);
    });

    testWidgets('context.spacing throws a FlutterError naming the missing '
        'extension when ThemeData.extensions omits it', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          // Deliberately built without design_system's extensions, the
          // way a stray `ThemeData(...)` override further down a tree
          // could — this is the exact mistake the assertion message
          // needs to explain.
          theme: ThemeData(useMaterial3: true),
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        () => capturedContext.spacing,
        throwsA(
          isA<FlutterError>().having(
            (e) => e.toString(),
            'message',
            allOf(
              contains('AppSpacingExtension'),
              contains('ThemeData.extensions'),
            ),
          ),
        ),
      );
    });
  });
}
