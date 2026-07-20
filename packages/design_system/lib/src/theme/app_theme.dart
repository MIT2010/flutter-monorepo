import 'package:flutter/material.dart';

import '../tokens/app_elevation_extension.dart';
import '../tokens/app_motion_extension.dart';
import '../tokens/app_semantic_colors.dart';
import '../tokens/app_shape_extension.dart';
import '../tokens/app_spacing_extension.dart';
import '../tokens/verdant_colors.dart';

/// The only two `ThemeData` factories the app ever needs.
///
/// Verdant (docs/VERDANT_DESIGN_SYSTEM.md §3.4): every `ColorScheme` role
/// is assigned explicitly from [VerdantColors] via the plain `ColorScheme`
/// constructor — deliberately **not** `ColorScheme.fromSeed`. `fromSeed`
/// runs Material's own HCT tonal-palette algorithm, which has a
/// recognizable signature regardless of the seed color fed into it; that
/// algorithm, not any particular token layered on top of it, was the real
/// reason this kit read as "a Material app" even after
/// `AppSpacingExtension`/`AppShapeExtension`/etc. already existed.
/// `surfaceTint` is set to fully transparent for the same reason — M3's
/// automatic elevation tinting (surfaces picking up a wash of `primary`
/// as they elevate) is itself a well-known Material signature; Verdant's
/// depth model (`AppElevationExtension`) communicates elevation through
/// borders/shadows/explicit surface-tone steps instead.
class AppTheme {
  const AppTheme._();

  // -------------------------------------------------------------------
  // Hand-authored ColorScheme roles (VERDANT_DESIGN_SYSTEM.md §3.4).
  // Every role assigned individually, contrast-checked by
  // test/theme/app_theme_contrast_test.dart — not derived, not
  // inherited from a shorter list of "seed" values.
  // -------------------------------------------------------------------

  static const Color _primaryLight = VerdantColors.moss60;
  static const Color _onPrimaryLight = VerdantColors.stone0;
  static const Color _primaryContainerLight = VerdantColors.moss10;
  static const Color _onPrimaryContainerLight = VerdantColors.moss80;

  static const Color _primaryDark = VerdantColors.moss40;
  static const Color _onPrimaryDark = VerdantColors.stone98;
  static const Color _primaryContainerDark = VerdantColors.moss90;
  static const Color _onPrimaryContainerDark = VerdantColors.moss20;

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
  /// platform default. Kept under Verdant deliberately
  /// (VERDANT_DESIGN_SYSTEM.md §0/§13.2) — the "feels like Material"
  /// complaint traces to color/shape/depth/motion, not typeface choice.
  /// Bundled rather than fetched at runtime (e.g. via `google_fonts`) so
  /// theme construction stays a pure, synchronous, offline operation --
  /// no network dependency in tests or on a user's first launch.
  static final TextTheme _textTheme = _baseTextTheme.apply(
    fontFamily: 'Plus Jakarta Sans',
  );

  /// Picks readable-on-[background] text: [VerdantColors.stone98] for a
  /// light/bright [background], [VerdantColors.stone0] for a dark one --
  /// used only when [light]/[dark]'s `primaryColor` override is set
  /// (Theme Studio's live seed-color picker), since an arbitrary chosen
  /// color has no pre-authored `onPrimary`/`onPrimaryContainer` pairing.
  /// The *default*, un-overridden theme never calls this — its
  /// `onPrimary`/etc. are individually hand-authored and contrast-tested
  /// above.
  static Color _onColorFor(Color background) {
    return background.computeLuminance() > 0.5
        ? VerdantColors.stone98
        : VerdantColors.stone0;
  }

  static ColorScheme _colorScheme({
    required Brightness brightness,
    required Color primary,
    required Color onPrimary,
    required Color primaryContainer,
    required Color onPrimaryContainer,
  }) {
    final isLight = brightness == Brightness.light;
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: isLight ? VerdantColors.stone70 : VerdantColors.stone40,
      onSecondary: isLight ? VerdantColors.stone0 : VerdantColors.stone98,
      secondaryContainer: isLight
          ? VerdantColors.stone10
          : VerdantColors.stone90,
      onSecondaryContainer: isLight
          ? VerdantColors.stone90
          : VerdantColors.stone10,
      tertiary: isLight ? VerdantColors.mist60 : VerdantColors.mist40,
      onTertiary: isLight ? VerdantColors.stone0 : VerdantColors.stone98,
      tertiaryContainer: isLight ? VerdantColors.mist10 : VerdantColors.mist90,
      onTertiaryContainer: isLight
          ? VerdantColors.mist70
          : VerdantColors.mist20,
      error: isLight ? VerdantColors.ember60 : VerdantColors.ember40,
      onError: isLight ? VerdantColors.stone0 : VerdantColors.stone98,
      errorContainer: isLight ? VerdantColors.ember10 : VerdantColors.ember90,
      onErrorContainer: isLight ? VerdantColors.ember70 : VerdantColors.ember20,
      surface: isLight ? VerdantColors.stone0 : VerdantColors.stone98,
      onSurface: isLight ? VerdantColors.stone90 : VerdantColors.stone10,
      surfaceContainerLowest: isLight
          ? VerdantColors.stone0
          : VerdantColors.stone98,
      surfaceContainerLow: isLight
          ? VerdantColors.stone10
          : VerdantColors.stone95,
      surfaceContainer: isLight ? VerdantColors.stone10 : VerdantColors.stone95,
      surfaceContainerHigh: isLight
          ? VerdantColors.stone20
          : VerdantColors.stone90,
      surfaceContainerHighest: isLight
          ? VerdantColors.stone20
          : VerdantColors.stone90,
      onSurfaceVariant: isLight ? VerdantColors.stone70 : VerdantColors.stone50,
      outline: isLight ? VerdantColors.stone40 : VerdantColors.stone60,
      outlineVariant: isLight ? VerdantColors.stone20 : VerdantColors.stone80,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isLight ? VerdantColors.stone90 : VerdantColors.stone10,
      onInverseSurface: isLight ? VerdantColors.stone0 : VerdantColors.stone90,
      inversePrimary: isLight ? VerdantColors.moss40 : VerdantColors.moss60,
      // Disables M3's automatic elevation surface-tinting — see class doc.
      surfaceTint: Colors.transparent,
    );
  }

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
    required AppElevationExtension elevation,
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
              xxxs: spacing.xxxs * spacingMultiplier,
              xxs: spacing.xxs * spacingMultiplier,
              xs: spacing.xs * spacingMultiplier,
              sm: spacing.sm * spacingMultiplier,
              md: spacing.md * spacingMultiplier,
              lg: spacing.lg * spacingMultiplier,
              xl: spacing.xl * spacingMultiplier,
              xxl: spacing.xxl * spacingMultiplier,
              xxxl: spacing.xxxl * spacingMultiplier,
              xxxxl: spacing.xxxxl * spacingMultiplier,
            ),
      semanticColors,
      radiusMultiplier == 1
          ? shape
          : shape.copyWith(
              radiusNone: shape.radiusNone * radiusMultiplier,
              radiusXs: shape.radiusXs * radiusMultiplier,
              radiusSm: shape.radiusSm * radiusMultiplier,
              radiusMd: shape.radiusMd * radiusMultiplier,
              radiusPill: shape.radiusPill * radiusMultiplier,
            ),
      elevation,
      motionSpeedMultiplier == 1
          ? motion
          : motion.copyWith(
              durationMicro: _scaled(
                motion.durationMicro,
                motionSpeedMultiplier,
              ),
              durationStandard: _scaled(
                motion.durationStandard,
                motionSpeedMultiplier,
              ),
              durationPanel: _scaled(
                motion.durationPanel,
                motionSpeedMultiplier,
              ),
              durationPage: _scaled(motion.durationPage, motionSpeedMultiplier),
            ),
    ];
  }

  /// A higher `speed` means shorter durations -- `speed: 2` plays every
  /// transition in half the time. Curves/spring physics params are left
  /// untouched: unlike a fixed duration, "speed" isn't a simple scalar
  /// input to a spring simulation, so scaling it isn't attempted here (see
  /// docs/VERDANT_DESIGN_SYSTEM.md §7 and the Theme Studio design notes).
  static Duration _scaled(Duration base, double speed) {
    return Duration(microseconds: (base.inMicroseconds / speed).round());
  }

  /// [primaryColor] overrides the primary/onPrimary/primaryContainer/
  /// onPrimaryContainer role family only -- every other role (secondary,
  /// surface, outline, etc.) stays fixed to the hand-authored Stone
  /// palette regardless, matching Verdant's "one saturated color, rest
  /// neutral" rule even while previewing a different accent
  /// (VERDANT_DESIGN_SYSTEM.md §11). Defaults to Moss when omitted.
  /// [spacingMultiplier]/[radiusMultiplier]/[motionSpeedMultiplier]
  /// default to `1` (no change). These overrides exist for
  /// `apps/widgetbook`'s Theme Studio addon to live-preview token changes
  /// through the same construction real screens use, rather than
  /// Widgetbook maintaining a second, duplicate theme recipe that could
  /// drift out of sync (§3 "extract once").
  static ThemeData light({
    Color? primaryColor,
    double spacingMultiplier = 1,
    double radiusMultiplier = 1,
    double motionSpeedMultiplier = 1,
  }) {
    final primary = primaryColor ?? _primaryLight;
    final onPrimary = primaryColor == null
        ? _onPrimaryLight
        : _onColorFor(primary);
    final primaryContainer = primaryColor == null
        ? _primaryContainerLight
        : Color.lerp(primary, VerdantColors.stone0, 0.82)!;
    final onPrimaryContainer = primaryColor == null
        ? _onPrimaryContainerLight
        : primary;

    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
      ),
      textTheme: _textTheme,
      extensions: _extensions(
        semanticColors: AppSemanticColors.light,
        elevation: AppElevationExtension.light,
        spacingMultiplier: spacingMultiplier,
        radiusMultiplier: radiusMultiplier,
        motionSpeedMultiplier: motionSpeedMultiplier,
      ),
    );
  }

  static ThemeData dark({
    Color? primaryColor,
    double spacingMultiplier = 1,
    double radiusMultiplier = 1,
    double motionSpeedMultiplier = 1,
  }) {
    final primary = primaryColor ?? _primaryDark;
    final onPrimary = primaryColor == null
        ? _onPrimaryDark
        : _onColorFor(primary);
    final primaryContainer = primaryColor == null
        ? _primaryContainerDark
        : Color.lerp(primary, VerdantColors.stone98, 0.78)!;
    final onPrimaryContainer = primaryColor == null
        ? _onPrimaryContainerDark
        : primary;

    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
      ),
      textTheme: _textTheme,
      extensions: _extensions(
        semanticColors: AppSemanticColors.dark,
        elevation: AppElevationExtension.dark,
        spacingMultiplier: spacingMultiplier,
        radiusMultiplier: radiusMultiplier,
        motionSpeedMultiplier: motionSpeedMultiplier,
      ),
    );
  }
}
