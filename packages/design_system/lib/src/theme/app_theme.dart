import 'package:flutter/material.dart';

import '../tokens/app_elevation_extension.dart';
import '../tokens/app_motion_extension.dart';
import '../tokens/app_semantic_colors.dart';
import '../tokens/app_shape_extension.dart';
import '../tokens/app_spacing_extension.dart';

/// The only two `ThemeData` factories the app ever needs. Dynamic color
/// (Material You) is applied at the app level via `DynamicColorBuilder`,
/// falling back to this static seeded scheme when unsupported (§16).
class AppTheme {
  const AppTheme._();

  /// Seed colors live here, not in a public token class — `ColorScheme`
  /// already derives every role (`primary`/`surface`/`error`/`onPrimary`/
  /// etc.) from these two values, so exposing them separately as
  /// `AppColors`/`AppColorsDark` was pure duplication with zero external
  /// consumers (§16 breaking-change audit, 2026-07-17).
  static const Color _seedLight = Color(0xFF2D6CDF);
  static const Color _seedDark = Color(0xFF9AB6FF);

  /// Full 15-slot M3 type scale (Display/Headline/Title/Body/Label ×
  /// Large/Medium/Small), inlined here rather than kept in a separate
  /// public `AppTypography` class — same redundancy reasoning as the
  /// seed colors above, minus the zero-consumer point (this one replaces
  /// a 6-slot class that genuinely carried brand decisions; those 6 are
  /// preserved verbatim below, the other 9 use Material 3's official
  /// baseline scale — previously filled in silently by
  /// `Typography.material2021()` since the old `TextTheme` only set 6 of
  /// 15 slots, so this changes nothing about what actually renders, only
  /// makes the fallback explicit).
  static const TextTheme _baseTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    // Brand override: bolder than M3's raw 400.
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
    // Brand override: bolder than M3's raw 400.
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    // Brand override: 20/w600 instead of M3's 22/w400.
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    // Brand override: 12 instead of M3's 11.
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  );

  /// Plus Jakarta Sans (SIL OFL 1.1, bundled locally under `fonts/` --
  /// see `fonts/OFL.txt` -- variable `wght` axis 200-800, true per-weight
  /// italics) applied over [_baseTextTheme] -- keeps every brand
  /// size/weight override above, only swaps the family away from the
  /// platform default (see docs/DESIGN_LANGUAGE.md §2). Bundled rather
  /// than fetched at runtime (e.g. via `google_fonts`) so theme
  /// construction stays a pure, synchronous, offline operation -- no
  /// network dependency in tests or on a user's first launch.
  static final TextTheme _textTheme = _baseTextTheme.apply(
    fontFamily: 'Plus Jakarta Sans',
  );

  /// Builds the token extensions for one brightness, scaling
  /// spacing/radius/motion away from [AppSpacingExtension.standard]/
  /// [AppShapeExtension.standard]/[AppMotionExtension.standard] only when a
  /// multiplier isn't 1 -- the default call (every real call site except
  /// Theme Studio, see `apps/widgetbook`) returns the exact singleton
  /// instances unchanged, so this stays behaviorally identical to the
  /// fixed-constant list it replaces (these tokens have no `==` override,
  /// so a `copyWith` clone with identical field values would still fail an
  /// `expect(theme.extension<T>(), AppSpacingExtension.standard)` check).
  static List<ThemeExtension<dynamic>> _extensions({
    required AppSemanticColors semanticColors,
    required double spacingMultiplier,
    required double radiusMultiplier,
    required double motionSpeedMultiplier,
  }) {
    const spacing = AppSpacingExtension.standard;
    const shape = AppShapeExtension.standard;
    const motion = AppMotionExtension.standard;

    return [
      spacingMultiplier == 1
          ? spacing
          : spacing.copyWith(
              xs: spacing.xs * spacingMultiplier,
              sm: spacing.sm * spacingMultiplier,
              md: spacing.md * spacingMultiplier,
              lg: spacing.lg * spacingMultiplier,
              xl: spacing.xl * spacingMultiplier,
            ),
      semanticColors,
      radiusMultiplier == 1
          ? shape
          : shape.copyWith(
              radiusSm: shape.radiusSm * radiusMultiplier,
              radiusMd: shape.radiusMd * radiusMultiplier,
              radiusLg: shape.radiusLg * radiusMultiplier,
              radiusPill: shape.radiusPill * radiusMultiplier,
            ),
      AppElevationExtension.standard,
      motionSpeedMultiplier == 1
          ? motion
          : motion.copyWith(
              durationFast: _scaled(motion.durationFast, motionSpeedMultiplier),
              durationMedium: _scaled(
                motion.durationMedium,
                motionSpeedMultiplier,
              ),
              durationSlow: _scaled(motion.durationSlow, motionSpeedMultiplier),
            ),
    ];
  }

  /// A higher `speed` means shorter durations -- `speed: 2` plays every
  /// transition in half the time. Curves/spring physics params are left
  /// untouched: unlike a fixed duration, "speed" isn't a simple scalar
  /// input to a spring simulation, so scaling it isn't attempted here (see
  /// docs/DESIGN_LANGUAGE.md §5 and the Theme Studio design notes).
  static Duration _scaled(Duration base, double speed) {
    return Duration(microseconds: (base.inMicroseconds / speed).round());
  }

  /// [seedColor] defaults to this kit's own seed; [spacingMultiplier]/
  /// [radiusMultiplier]/[motionSpeedMultiplier] default to `1` (no change).
  /// These overrides exist for `apps/widgetbook`'s Theme Studio addon to
  /// live-preview token changes through the same construction real screens
  /// use, rather than Widgetbook maintaining a second, duplicate theme
  /// recipe that could drift out of sync (§3 "extract once").
  static ThemeData light({
    Color? seedColor,
    double spacingMultiplier = 1,
    double radiusMultiplier = 1,
    double motionSpeedMultiplier = 1,
  }) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor ?? _seedLight),
    textTheme: _textTheme,
    extensions: _extensions(
      semanticColors: AppSemanticColors.light,
      spacingMultiplier: spacingMultiplier,
      radiusMultiplier: radiusMultiplier,
      motionSpeedMultiplier: motionSpeedMultiplier,
    ),
  );

  static ThemeData dark({
    Color? seedColor,
    double spacingMultiplier = 1,
    double radiusMultiplier = 1,
    double motionSpeedMultiplier = 1,
  }) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor ?? _seedDark,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme,
    extensions: _extensions(
      semanticColors: AppSemanticColors.dark,
      spacingMultiplier: spacingMultiplier,
      radiusMultiplier: radiusMultiplier,
      motionSpeedMultiplier: motionSpeedMultiplier,
    ),
  );
}
