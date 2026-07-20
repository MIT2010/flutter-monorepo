import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppExpressiveCard', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppExpressiveCard(child: Text('content'))),
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
            body: AppExpressiveCard(
              onTap: () => tapped = true,
              child: const Text('content'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppExpressiveCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets(
      'border shifts from outlineVariant to primary on press, and back on '
      'release -- no shape or elevation change',
      (tester) async {
        final cardKey = GlobalKey();
        final theme = AppTheme.light();
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: AppExpressiveCard(
                key: cardKey,
                onTap: () {},
                child: const Text('content'),
              ),
            ),
          ),
        );

        BoxDecoration decorationOf() {
          final container = tester.widget<AnimatedContainer>(
            find.descendant(
              of: find.byKey(cardKey),
              matching: find.byType(AnimatedContainer),
            ),
          );
          return container.decoration as BoxDecoration;
        }

        final restBorder = decorationOf().border as Border;
        expect(restBorder.top.color, theme.colorScheme.outlineVariant);

        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(cardKey)),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));

        final pressedBorder = decorationOf().border as Border;
        expect(pressedBorder.top.color, theme.colorScheme.primary);

        await gesture.up();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));

        final releasedBorder = decorationOf().border as Border;
        expect(releasedBorder.top.color, theme.colorScheme.outlineVariant);
      },
    );

    testWidgets(
      'jumps instantly to the pressed border color (no animation) when '
      'reduce motion is on',
      (tester) async {
        final cardKey = GlobalKey();
        final theme = AppTheme.light();
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: MaterialApp(
              theme: theme,
              home: Scaffold(
                body: AppExpressiveCard(
                  key: cardKey,
                  onTap: () {},
                  child: const Text('content'),
                ),
              ),
            ),
          ),
        );

        BoxDecoration decorationOf() {
          final container = tester.widget<AnimatedContainer>(
            find.descendant(
              of: find.byKey(cardKey),
              matching: find.byType(AnimatedContainer),
            ),
          );
          return container.decoration as BoxDecoration;
        }

        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(cardKey)),
        );
        await tester.pump();

        final pressedBorder = decorationOf().border as Border;
        expect(pressedBorder.top.color, theme.colorScheme.primary);

        await gesture.up();
        await tester.pump();

        final releasedBorder = decorationOf().border as Border;
        expect(releasedBorder.top.color, theme.colorScheme.outlineVariant);
      },
    );
  });
}
