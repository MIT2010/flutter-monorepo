import 'package:flutter/material.dart';

/// Durations/curves for widget-state transitions.
///
/// "Natural, confident, predictable, elegant — never playful, never
/// bouncy." One curve family,
/// two directions, zero overshoot: [curveEnter] (decisive start, gentle
/// settle) for anything appearing/growing, [curveExit] (front-loaded,
/// quick) for anything disappearing — attention should leave a screen
/// faster than it arrived. Four duration tiers instead of three, adding a
/// distinct `page` tier for full-screen/route transitions.
///
/// [curveEmphasis] is the system's one deliberately-distinct third curve —
/// reserved for a small set of affirmative moments (primary button
/// press-feedback, a selection confirming). **Still zero overshoot** — the
/// "never bouncy" rule above is not being relaxed, an overshoot/spring
/// curve was considered and rejected as a signature specifically because
/// it would contradict this file's own established philosophy. What makes
/// it feel distinct instead is pace, not shape: almost all deceleration
/// happens in the first fraction of the curve (steeper front-load than
/// even [curveExit]), reading as a crisp "snap to attention" rather than
/// [curveEnter]'s gentle settle.
///
/// [spring] is kept as reusable Flutter physics infrastructure
/// (`SpringDescription`/`SpringSimulation` from `package:flutter/physics.dart`)
/// but is **not** part of the default motion vocabulary — no component
/// reaches for it by default, since `AppExpressiveCard`'s spring-driven
/// shape-morph was retired in favor of a quieter hairline-border-shift
/// treatment. Not deleted outright, since the underlying physics
/// capability is genuinely useful and harmless left unused.
@immutable
class AppMotionExtension extends ThemeExtension<AppMotionExtension> {
  const AppMotionExtension({
    required this.durationMicro,
    required this.durationStandard,
    required this.durationPanel,
    required this.durationPage,
    required this.curveEnter,
    required this.curveExit,
    required this.curveEmphasis,
    required this.spring,
  });

  /// Brightness-independent, like [AppSpacingExtension.standard] — motion
  /// timing doesn't change between light and dark.
  static const AppMotionExtension standard = AppMotionExtension(
    durationMicro: Duration(milliseconds: 120),
    durationStandard: Duration(milliseconds: 220),
    durationPanel: Duration(milliseconds: 320),
    durationPage: Duration(milliseconds: 380),
    // Decisive start (near-linear initial velocity), long gentle settle,
    // zero overshoot.
    curveEnter: Cubic(0.2, 0.0, 0.0, 1.0),
    // Quick, front-loaded departure — attention leaves faster than it
    // arrives.
    curveExit: Cubic(0.4, 0.0, 0.8, 1.0),
    // Nearly all deceleration in the first fraction, zero overshoot —
    // "snap to attention," not a bounce. See class doc for why this
    // exists as a third curve instead of reaching for an overshoot/spring
    // treatment.
    curveEmphasis: Cubic(0.05, 0.9, 0.1, 1.0),
    // Retained capability, unused by any component by default post-Tahap
    // 3 — see class doc.
    spring: SpringDescription(mass: 1, stiffness: 300, damping: 20),
  );

  /// Press/release state changes, checkbox/switch toggle, focus ring
  /// appearance.
  final Duration durationMicro;

  /// Expand/collapse, tab switch, in-place content swap.
  final Duration durationStandard;

  /// Bottom sheet / dialog entrance, dropdown/menu open.
  final Duration durationPanel;

  /// Full-screen/route transitions.
  final Duration durationPage;

  final Curve curveEnter;
  final Curve curveExit;
  final Curve curveEmphasis;
  final SpringDescription spring;

  @override
  AppMotionExtension copyWith({
    Duration? durationMicro,
    Duration? durationStandard,
    Duration? durationPanel,
    Duration? durationPage,
    Curve? curveEnter,
    Curve? curveExit,
    Curve? curveEmphasis,
    SpringDescription? spring,
  }) {
    return AppMotionExtension(
      durationMicro: durationMicro ?? this.durationMicro,
      durationStandard: durationStandard ?? this.durationStandard,
      durationPanel: durationPanel ?? this.durationPanel,
      durationPage: durationPage ?? this.durationPage,
      curveEnter: curveEnter ?? this.curveEnter,
      curveExit: curveExit ?? this.curveExit,
      curveEmphasis: curveEmphasis ?? this.curveEmphasis,
      spring: spring ?? this.spring,
    );
  }

  @override
  AppMotionExtension lerp(ThemeExtension<AppMotionExtension>? other, double t) {
    if (other is! AppMotionExtension) return this;
    return AppMotionExtension(
      durationMicro: _lerpDuration(durationMicro, other.durationMicro, t),
      durationStandard: _lerpDuration(
        durationStandard,
        other.durationStandard,
        t,
      ),
      durationPanel: _lerpDuration(durationPanel, other.durationPanel, t),
      durationPage: _lerpDuration(durationPage, other.durationPage, t),
      // Curves are functions, not interpolatable values -- snap at the
      // midpoint like most non-numeric ThemeExtension fields do.
      curveEnter: t < 0.5 ? curveEnter : other.curveEnter,
      curveExit: t < 0.5 ? curveExit : other.curveExit,
      curveEmphasis: t < 0.5 ? curveEmphasis : other.curveEmphasis,
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
