import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppAvatar', () {
    testWidgets('shows initials when no image is given', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AppAvatar(initials: 'MI')),
        ),
      );

      expect(find.text('MI'), findsOneWidget);
    });

    testWidgets('falls back to initials when the image fails to load', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: AppAvatar(
              initials: 'MI',
              image: AssetImage('nonexistent_test_asset.png'),
            ),
          ),
        ),
      );
      // AssetImage resolution/decode failure surfaces asynchronously.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('MI'), findsOneWidget);
    });

    testWidgets('sizes scale with the space token scale (small < medium '
        '< large)', (tester) async {
      Future<double> radiusOf(AppAvatarSize size) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(
              body: AppAvatar(initials: 'MI', size: size),
            ),
          ),
        );
        return tester.widget<CircleAvatar>(find.byType(CircleAvatar)).radius!;
      }

      final small = await radiusOf(AppAvatarSize.small);
      final medium = await radiusOf(AppAvatarSize.medium);
      final large = await radiusOf(AppAvatarSize.large);

      expect(small, lessThan(medium));
      expect(medium, lessThan(large));
    });

    testWidgets(
      'ringed keeps the same overall diameter as unringed (inset ring, '
      'not additive)',
      (tester) async {
        Future<Size> boundsOf({required bool ringed}) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light(),
              home: Scaffold(
                body: AppAvatar(initials: 'MI', ringed: ringed),
              ),
            ),
          );
          return tester.getSize(find.byType(AppAvatar));
        }

        final unringed = await boundsOf(ringed: false);
        final ringed = await boundsOf(ringed: true);

        expect(ringed, unringed);
      },
    );
  });
}
