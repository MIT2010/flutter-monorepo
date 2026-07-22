import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden_harness.dart';

// No "with a real image" golden -- design_system ships no test-fixture
// image asset (a leaf package with no bundled assets, §16), and a
// network image would make this golden non-deterministic across runs.
// The initials fallback path is what every avatar renders without a
// caller-supplied image anyway, so it's the one worth pinning here.

void main() {
  group('AppAvatar golden', () {
    testWidgets('small, medium, large sizes (light)', (tester) async {
      await pumpGolden(
        tester,
        theme: lightTheme,
        surfaceSize: const Size(160, 60),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppAvatar(initials: 'A', size: AppAvatarSize.small),
            AppAvatar(initials: 'MI', size: AppAvatarSize.medium),
            AppAvatar(initials: 'MI', size: AppAvatarSize.large),
          ],
        ),
      );
      await expectLater(
        find.byType(Row),
        matchesGoldenFile('goldens/app_avatar_sizes_light.png'),
      );
    });

    testWidgets('small, medium, large sizes (dark)', (tester) async {
      await pumpGolden(
        tester,
        theme: darkTheme,
        surfaceSize: const Size(160, 60),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppAvatar(initials: 'A', size: AppAvatarSize.small),
            AppAvatar(initials: 'MI', size: AppAvatarSize.medium),
            AppAvatar(initials: 'MI', size: AppAvatarSize.large),
          ],
        ),
      );
      await expectLater(
        find.byType(Row),
        matchesGoldenFile('goldens/app_avatar_sizes_dark.png'),
      );
    });

    testWidgets(
      'ringed facepile -- stone.20 separator, same bounds as unringed '
      '(light)',
      (tester) async {
        const facepileKey = Key('facepile');
        await pumpGolden(
          tester,
          theme: lightTheme,
          surfaceSize: const Size(120, 60),
          child: const Stack(
            key: facepileKey,
            children: [
              AppAvatar(initials: 'AB', ringed: true),
              Positioned(
                left: 24,
                child: AppAvatar(initials: 'CD', ringed: true),
              ),
            ],
          ),
        );
        await expectLater(
          find.byKey(facepileKey),
          matchesGoldenFile('goldens/app_avatar_ringed_light.png'),
        );
      },
    );

    testWidgets(
      'ringed facepile -- stone.20 separator, same bounds as unringed '
      '(dark)',
      (tester) async {
        const facepileKey = Key('facepile');
        await pumpGolden(
          tester,
          theme: darkTheme,
          surfaceSize: const Size(120, 60),
          child: const Stack(
            key: facepileKey,
            children: [
              AppAvatar(initials: 'AB', ringed: true),
              Positioned(
                left: 24,
                child: AppAvatar(initials: 'CD', ringed: true),
              ),
            ],
          ),
        );
        await expectLater(
          find.byKey(facepileKey),
          matchesGoldenFile('goldens/app_avatar_ringed_dark.png'),
        );
      },
    );
  });
}
