import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Spacing scale as a [ThemeExtension], registered on every [ThemeData]
/// this package builds (`AppTheme.light()`/`dark()`) and read via
/// `context.spacing` — replaces the old static `AppSpacing` class so
/// spacing lives in `Theme.of(context)` like every other design token,
/// supports per-subtree override, and gets free `lerp` across
/// `AnimatedTheme` transitions.
///
/// Fine-grained at the bottom (precise micro-adjustments), deliberately
/// generous jumps at the top (macro composition, page margins) — every
/// `context.spacing.xs`/`.sm`/etc. call site picks up a value change
/// automatically, no code changes needed.
@immutable
class AppSpacingExtension extends ThemeExtension<AppSpacingExtension> {
  const AppSpacingExtension({
    required this.xxxs,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.xxxxl,
  });

  /// The single spacing scale both `AppTheme.light()` and `.dark()`
  /// register — spacing doesn't vary with brightness, unlike color.
  static const AppSpacingExtension standard = AppSpacingExtension(
    xxxs: 2.0,
    xxs: 4.0,
    xs: 8.0,
    sm: 12.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
    xxl: 48.0,
    xxxl: 64.0,
    xxxxl: 96.0,
  );

  /// Icon-to-badge micro nudges only.
  final double xxxs;

  /// Icon-to-label gap, tight inline groups.
  final double xxs;

  /// Internal padding of small controls (chips, compact buttons).
  final double xs;

  /// Internal padding of standard controls (text fields, list items).
  final double sm;

  /// Default component-to-component gap.
  final double md;

  /// Card internal padding; gap between related groups.
  final double lg;

  /// Gap between unrelated sections on the same screen.
  final double xl;

  /// Page-level top/bottom margin (mobile).
  final double xxl;

  /// Page-level side margin (tablet/desktop); "chapter" breaks.
  final double xxxl;

  /// Hero/landing composition breathing room (desktop/web only).
  final double xxxxl;

  @override
  AppSpacingExtension copyWith({
    double? xxxs,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? xxxxl,
  }) {
    return AppSpacingExtension(
      xxxs: xxxs ?? this.xxxs,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      xxxxl: xxxxl ?? this.xxxxl,
    );
  }

  @override
  AppSpacingExtension lerp(
    ThemeExtension<AppSpacingExtension>? other,
    double t,
  ) {
    if (other is! AppSpacingExtension) return this;
    return AppSpacingExtension(
      xxxs: lerpDouble(xxxs, other.xxxs, t)!,
      xxs: lerpDouble(xxs, other.xxs, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
      xxxxl: lerpDouble(xxxxl, other.xxxxl, t)!,
    );
  }
}
