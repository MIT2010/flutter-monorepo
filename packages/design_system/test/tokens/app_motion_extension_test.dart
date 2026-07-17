import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMotionExtension', () {
    test('standard durations are strictly increasing', () {
      const motion = AppMotionExtension.standard;
      expect(motion.durationFast, lessThan(motion.durationMedium));
      expect(motion.durationMedium, lessThan(motion.durationSlow));
    });

    test('standard spring has positive mass/stiffness/damping', () {
      final spring = AppMotionExtension.standard.spring;
      expect(spring.mass, greaterThan(0));
      expect(spring.stiffness, greaterThan(0));
      expect(spring.damping, greaterThan(0));
    });

    test('copyWith overrides only the given fields', () {
      const motion = AppMotionExtension.standard;
      final copy = motion.copyWith(
        durationMedium: const Duration(milliseconds: 500),
      );

      expect(copy.durationMedium, const Duration(milliseconds: 500));
      expect(copy.durationFast, motion.durationFast);
      expect(copy.durationSlow, motion.durationSlow);
      expect(copy.curveStandard, motion.curveStandard);
      expect(copy.spring, motion.spring);
    });

    test('lerp interpolates durations and spring params linearly', () {
      const a = AppMotionExtension(
        durationFast: Duration.zero,
        durationMedium: Duration.zero,
        durationSlow: Duration.zero,
        curveStandard: Curves.linear,
        curveEmphasized: Curves.linear,
        spring: SpringDescription(mass: 0, stiffness: 0, damping: 0),
      );
      const b = AppMotionExtension(
        durationFast: Duration(milliseconds: 100),
        durationMedium: Duration(milliseconds: 100),
        durationSlow: Duration(milliseconds: 100),
        curveStandard: Curves.ease,
        curveEmphasized: Curves.ease,
        spring: SpringDescription(mass: 10, stiffness: 10, damping: 10),
      );

      final mid = a.lerp(b, 0.5);
      expect(mid.durationMedium, const Duration(milliseconds: 50));
      expect(mid.spring.mass, 5.0);
    });

    test('lerp returns this unchanged when other is a different type', () {
      const motion = AppMotionExtension.standard;
      expect(motion.lerp(null, 0.5), motion);
    });
  });
}
