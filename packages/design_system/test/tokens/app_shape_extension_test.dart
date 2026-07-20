import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppShapeExtension', () {
    test(
      'Verdant scale (none/xs/sm/md/pill) is strictly increasing, pill is largest',
      () {
        const shape = AppShapeExtension.standard;
        expect(shape.radiusNone, lessThan(shape.radiusXs));
        expect(shape.radiusXs, lessThan(shape.radiusSm));
        expect(shape.radiusSm, lessThan(shape.radiusMd));
        expect(shape.radiusMd, lessThan(shape.radiusPill));
      },
    );

    test(
      'expressive is a non-uniform BorderRadius, not a plain rounded rect',
      () {
        final expressive = AppShapeExtension.standard.expressive;
        expect(expressive.topLeft, isNot(expressive.topRight));
        expect(expressive.bottomLeft, isNot(expressive.bottomRight));
        expect(expressive.topLeft, expressive.bottomRight);
        expect(expressive.topRight, expressive.bottomLeft);
      },
    );

    test('copyWith overrides only the given fields', () {
      const shape = AppShapeExtension.standard;
      final copy = shape.copyWith(radiusMd: 20.0);

      expect(copy.radiusMd, 20.0);
      expect(copy.radiusNone, shape.radiusNone);
      expect(copy.radiusXs, shape.radiusXs);
      expect(copy.radiusSm, shape.radiusSm);
      expect(copy.radiusLg, shape.radiusLg);
      expect(copy.radiusPill, shape.radiusPill);
      expect(copy.expressive, shape.expressive);
    });

    test('lerp interpolates radii and the expressive BorderRadius', () {
      const a = AppShapeExtension(
        radiusNone: 0,
        radiusXs: 0,
        radiusSm: 0,
        radiusMd: 0,
        radiusLg: 0,
        radiusPill: 0,
        expressive: BorderRadius.zero,
      );
      const b = AppShapeExtension(
        radiusNone: 10,
        radiusXs: 10,
        radiusSm: 10,
        radiusMd: 10,
        radiusLg: 10,
        radiusPill: 10,
        expressive: BorderRadius.all(Radius.circular(10)),
      );

      final mid = a.lerp(b, 0.5);
      expect(mid.radiusMd, 5.0);
      expect(mid.expressive.topLeft.x, 5.0);
    });

    test('lerp returns this unchanged when other is a different type', () {
      const shape = AppShapeExtension.standard;
      expect(shape.lerp(null, 0.5), shape);
    });
  });
}
