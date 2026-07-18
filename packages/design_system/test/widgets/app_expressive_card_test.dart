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
      'lifts elevation gradually via spring physics when reduce motion is off',
      (tester) async {
        final cardKey = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppExpressiveCard(
                key: cardKey,
                onTap: () {},
                child: const Text('content'),
              ),
            ),
          ),
        );

        Material materialOf() => tester.widget<Material>(
          find.descendant(
            of: find.byKey(cardKey),
            matching: find.byType(Material),
          ),
        );

        final initialElevation = materialOf().elevation;

        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(cardKey)),
        );
        // Two pumps, not one: the ticker only anchors its own start time on
        // its first post-start frame callback, so a single pump(duration)
        // right after starting the gesture reports elapsed=0, not
        // `duration` -- the first pump anchors it, the second observes
        // real progress.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 16));

        final midElevation = materialOf().elevation;
        // Still mid-flight after one frame -- a spring simulation doesn't
        // reach its target that fast, unlike the reduce-motion instant jump
        // verified below.
        expect(midElevation, greaterThan(initialElevation));
        expect(midElevation, lessThan(AppElevationExtension.standard.level3));

        await gesture.up();
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'jumps instantly to the tapped elevation (no spring animation) when '
      'reduce motion is on',
      (tester) async {
        final cardKey = GlobalKey();
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: MaterialApp(
              theme: AppTheme.light(),
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

        Material materialOf() => tester.widget<Material>(
          find.descendant(
            of: find.byKey(cardKey),
            matching: find.byType(Material),
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.byKey(cardKey)),
        );
        await tester.pump();

        expect(materialOf().elevation, AppElevationExtension.standard.level3);

        await gesture.up();
        await tester.pump();

        expect(materialOf().elevation, AppElevationExtension.standard.level1);
      },
    );
  });
}
