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
  static const TextTheme _textTheme = TextTheme(
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

  static const List<ThemeExtension<dynamic>> _lightExtensions = [
    AppSpacingExtension.standard,
    AppSemanticColors.light,
    AppShapeExtension.standard,
    AppElevationExtension.standard,
    AppMotionExtension.standard,
  ];

  static const List<ThemeExtension<dynamic>> _darkExtensions = [
    AppSpacingExtension.standard,
    AppSemanticColors.dark,
    AppShapeExtension.standard,
    AppElevationExtension.standard,
    AppMotionExtension.standard,
  ];

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seedLight),
    textTheme: _textTheme,
    extensions: _lightExtensions,
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedDark,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme,
    extensions: _darkExtensions,
  );
}
