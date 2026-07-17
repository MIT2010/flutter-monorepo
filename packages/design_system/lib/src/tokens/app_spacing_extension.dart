import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Spacing scale as a [ThemeExtension], registered on every [ThemeData]
/// this package builds (`AppTheme.light()`/`dark()`) and read via
/// `context.spacing` — replaces the old static `AppSpacing` class so
/// spacing lives in `Theme.of(context)` like every other design token,
/// supports per-subtree override, and gets free `lerp` across
/// `AnimatedTheme` transitions (§16).
@immutable
class AppSpacingExtension extends ThemeExtension<AppSpacingExtension> {
  const AppSpacingExtension({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  /// The single spacing scale both `AppTheme.light()` and `.dark()`
  /// register — spacing doesn't vary with brightness, unlike color.
  static const AppSpacingExtension standard = AppSpacingExtension(
    xs: 4.0,
    sm: 8.0,
    md: 16.0,
    lg: 24.0,
    xl: 32.0,
  );

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;

  @override
  AppSpacingExtension copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
  }) {
    return AppSpacingExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  AppSpacingExtension lerp(
    ThemeExtension<AppSpacingExtension>? other,
    double t,
  ) {
    if (other is! AppSpacingExtension) return this;
    return AppSpacingExtension(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
    );
  }
}
