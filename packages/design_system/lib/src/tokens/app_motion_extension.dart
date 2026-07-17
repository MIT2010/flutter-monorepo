import 'package:flutter/material.dart';

/// Standard durations/curves for widget-state transitions, plus a
/// spring-physics option for interactions that should feel more alive
/// than a fixed-duration ease curve (M3 Expressive's motion direction —
/// implemented with Flutter's own native `SpringDescription`/
/// `SpringSimulation` from `package:flutter/physics.dart`, not the
/// m3e_design package; see the design_system token-upgrade proposal,
/// 2026-07-17, for why that package isn't a core-kit dependency).
@immutable
class AppMotionExtension extends ThemeExtension<AppMotionExtension> {
  const AppMotionExtension({
    required this.durationFast,
    required this.durationMedium,
    required this.durationSlow,
    required this.curveStandard,
    required this.curveEmphasized,
    required this.spring,
  });

  /// Brightness-independent, like [AppSpacingExtension.standard] — motion
  /// timing doesn't change between light and dark.
  static const AppMotionExtension standard = AppMotionExtension(
    durationFast: Duration(milliseconds: 100),
    durationMedium: Duration(milliseconds: 250),
    durationSlow: Duration(milliseconds: 400),
    curveStandard: Curves.easeInOut,
    curveEmphasized: Curves.easeInOutCubicEmphasized,
    // Mass/stiffness/damping tuned for a lively-but-settled feel — not
    // too bouncy (a status badge or card shouldn't wobble), not so
    // over-damped it looks identical to a plain ease curve.
    spring: SpringDescription(mass: 1, stiffness: 300, damping: 20),
  );

  final Duration durationFast;
  final Duration durationMedium;
  final Duration durationSlow;
  final Curve curveStandard;
  final Curve curveEmphasized;
  final SpringDescription spring;

  @override
  AppMotionExtension copyWith({
    Duration? durationFast,
    Duration? durationMedium,
    Duration? durationSlow,
    Curve? curveStandard,
    Curve? curveEmphasized,
    SpringDescription? spring,
  }) {
    return AppMotionExtension(
      durationFast: durationFast ?? this.durationFast,
      durationMedium: durationMedium ?? this.durationMedium,
      durationSlow: durationSlow ?? this.durationSlow,
      curveStandard: curveStandard ?? this.curveStandard,
      curveEmphasized: curveEmphasized ?? this.curveEmphasized,
      spring: spring ?? this.spring,
    );
  }

  @override
  AppMotionExtension lerp(ThemeExtension<AppMotionExtension>? other, double t) {
    if (other is! AppMotionExtension) return this;
    return AppMotionExtension(
      durationFast: _lerpDuration(durationFast, other.durationFast, t),
      durationMedium: _lerpDuration(durationMedium, other.durationMedium, t),
      durationSlow: _lerpDuration(durationSlow, other.durationSlow, t),
      // Curves are functions, not interpolatable values -- snap at the
      // midpoint like most non-numeric ThemeExtension fields do.
      curveStandard: t < 0.5 ? curveStandard : other.curveStandard,
      curveEmphasized: t < 0.5 ? curveEmphasized : other.curveEmphasized,
      spring: SpringDescription(
        mass: _lerpDouble(spring.mass, other.spring.mass, t),
        stiffness: _lerpDouble(spring.stiffness, other.spring.stiffness, t),
        damping: _lerpDouble(spring.damping, other.spring.damping, t),
      ),
    );
  }

  static Duration _lerpDuration(Duration a, Duration b, double t) {
    final us = a.inMicroseconds + (b.inMicroseconds - a.inMicroseconds) * t;
    return Duration(microseconds: us.round());
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
