import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppElevationExtension', () {
    test(
      'standard matches the M3 official elevation scale (0/1/3/6/8/12dp)',
      () {
        const elevation = AppElevationExtension.standard;
        expect(elevation.level0, 0.0);
        expect(elevation.level1, 1.0);
        expect(elevation.level2, 3.0);
        expect(elevation.level3, 6.0);
        expect(elevation.level4, 8.0);
        expect(elevation.level5, 12.0);
      },
    );

    test('copyWith overrides only the given field', () {
      const elevation = AppElevationExtension.standard;
      final copy = elevation.copyWith(level3: 7.0);

      expect(copy.level3, 7.0);
      expect(copy.level0, elevation.level0);
      expect(copy.level5, elevation.level5);
    });

    test('lerp interpolates every level linearly', () {
      const a = AppElevationExtension(
        level0: 0,
        level1: 0,
        level2: 0,
        level3: 0,
        level4: 0,
        level5: 0,
      );
      const b = AppElevationExtension(
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
      const elevation = AppElevationExtension.standard;
      expect(elevation.lerp(null, 0.5), elevation);
    });
  });
}
