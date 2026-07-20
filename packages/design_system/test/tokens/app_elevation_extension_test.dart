import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppElevationExtension', () {
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
      final copy = elevation.copyWith(resting: elevation.flush);

      expect(copy.resting, elevation.flush);
      expect(copy.flush, elevation.flush);
      expect(copy.lifted, elevation.lifted);
      expect(copy.floating, elevation.floating);
    });

    test('lerp snaps AppDepthLevel fields at the midpoint', () {
      const levelA = AppDepthLevel(border: null, shadow: []);
      const levelB = AppDepthLevel(border: Border(), shadow: [BoxShadow()]);
      const a = AppElevationExtension(
        flush: levelA,
        resting: levelA,
        lifted: levelA,
        floating: levelA,
      );
      const b = AppElevationExtension(
        flush: levelB,
        resting: levelB,
        lifted: levelB,
        floating: levelB,
      );

      expect(a.lerp(b, 0.3).flush, levelA);
      expect(a.lerp(b, 0.7).flush, levelB);
    });

    test('lerp returns this unchanged when other is a different type', () {
      const elevation = AppElevationExtension.light;
      expect(elevation.lerp(null, 0.5), elevation);
    });
  });
}
