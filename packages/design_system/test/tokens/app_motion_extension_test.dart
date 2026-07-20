import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMotionExtension', () {
    test('standard durations are strictly increasing', () {
      const motion = AppMotionExtension.standard;
      expect(motion.durationMicro, lessThan(motion.durationStandard));
      expect(motion.durationStandard, lessThan(motion.durationPanel));
      expect(motion.durationPanel, lessThan(motion.durationPage));
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
        durationStandard: const Duration(milliseconds: 500),
      );

      expect(copy.durationStandard, const Duration(milliseconds: 500));
      expect(copy.durationMicro, motion.durationMicro);
      expect(copy.durationPanel, motion.durationPanel);
      expect(copy.durationPage, motion.durationPage);
      expect(copy.curveEnter, motion.curveEnter);
      expect(copy.spring, motion.spring);
    });

    test('lerp interpolates durations and spring params linearly', () {
      const a = AppMotionExtension(
        durationMicro: Duration.zero,
        durationStandard: Duration.zero,
        durationPanel: Duration.zero,
        durationPage: Duration.zero,
        curveEnter: Curves.linear,
        curveExit: Curves.linear,
        spring: SpringDescription(mass: 0, stiffness: 0, damping: 0),
      );
      const b = AppMotionExtension(
        durationMicro: Duration(milliseconds: 100),
        durationStandard: Duration(milliseconds: 100),
        durationPanel: Duration(milliseconds: 100),
        durationPage: Duration(milliseconds: 100),
        curveEnter: Curves.ease,
        curveExit: Curves.ease,
        spring: SpringDescription(mass: 10, stiffness: 10, damping: 10),
      );

      final mid = a.lerp(b, 0.5);
      expect(mid.durationStandard, const Duration(milliseconds: 50));
      expect(mid.spring.mass, 5.0);
    });

    test('lerp returns this unchanged when other is a different type', () {
      const motion = AppMotionExtension.standard;
      expect(motion.lerp(null, 0.5), motion);
    });
  });
}
