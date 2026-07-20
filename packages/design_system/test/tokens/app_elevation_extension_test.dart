import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppElevationExtension', () {
    test('legacy level0-5 still match the M3 dp scale (pending Tahap 2)', () {
      for (final elevation in [
        AppElevationExtension.light,
        AppElevationExtension.dark,
      ]) {
        expect(elevation.level0, 0.0);
        expect(elevation.level1, 1.0);
        expect(elevation.level2, 3.0);
        expect(elevation.level3, 6.0);
        expect(elevation.level4, 8.0);
        expect(elevation.level5, 12.0);
      }
    });

    test('flush has no border and no shadow', () {
      for (final elevation in [
        AppElevationExtension.light,
        AppElevationExtension.dark,
      ]) {
        expect(elevation.flush.border, isNull);
        expect(elevation.flush.shadow, isEmpty);
      }
    });

    test('resting has a border but no shadow', () {
      for (final elevation in [
        AppElevationExtension.light,
        AppElevationExtension.dark,
      ]) {
        expect(elevation.resting.border, isNotNull);
        expect(elevation.resting.shadow, isEmpty);
      }
    });

    test('lifted has both a border and a subtle shadow', () {
      for (final elevation in [
        AppElevationExtension.light,
        AppElevationExtension.dark,
      ]) {
        expect(elevation.lifted.border, isNotNull);
        expect(elevation.lifted.shadow, isNotEmpty);
      }
    });

    test(
      'floating has a shadow and an explicit tone-shifted surfaceColor, no border',
      () {
        for (final elevation in [
          AppElevationExtension.light,
          AppElevationExtension.dark,
        ]) {
          expect(elevation.floating.border, isNull);
          expect(elevation.floating.shadow, isNotEmpty);
          expect(elevation.floating.surfaceColor, isNotNull);
        }
      },
    );

    test(
      'floating surfaceColor differs between light and dark (each mode tuned independently)',
      () {
        expect(
          AppElevationExtension.light.floating.surfaceColor,
          isNot(AppElevationExtension.dark.floating.surfaceColor),
        );
      },
    );

    test('copyWith overrides only the given field', () {
      const elevation = AppElevationExtension.light;
      final copy = elevation.copyWith(level3: 7.0);

      expect(copy.level3, 7.0);
      expect(copy.level0, elevation.level0);
      expect(copy.level5, elevation.level5);
      expect(copy.flush, elevation.flush);
      expect(copy.resting, elevation.resting);
    });

    test('lerp interpolates every numeric level linearly', () {
      const level = AppDepthLevel(border: null, shadow: []);
      const a = AppElevationExtension(
        flush: level,
        resting: level,
        lifted: level,
        floating: level,
        level0: 0,
        level1: 0,
        level2: 0,
        level3: 0,
        level4: 0,
        level5: 0,
      );
      const b = AppElevationExtension(
        flush: level,
        resting: level,
        lifted: level,
        floating: level,
        level0: 10,
        level1: 10,
        level2: 10,
        level3: 10,
        level4: 10,
        level5: 10,
      );

      final mid = a.lerp(b, 0.5);
      expect(mid.level3, 5.0);
    });

    test('lerp returns this unchanged when other is a different type', () {
      const elevation = AppElevationExtension.light;
      expect(elevation.lerp(null, 0.5), elevation);
    });
  });
}
