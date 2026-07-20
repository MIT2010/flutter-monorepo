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
///
/// Component-level `ThemeData` fields (`elevatedButtonTheme`,
/// `inputDecorationTheme`, `dialogTheme`, `snackBarTheme`) carry §10's
/// per-component shape/depth decisions so the six widgets built against
/// this theme (Button/Card/TextField/Navigation/Dialog-Sheet/
/// Snackbar-Badge, §10.1-10.6) stay thin, theme-driven wrappers — the same
/// pattern the original five widgets already used.
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

  /// The single most common commitment point in the UI — deserves the
  /// most restraint, not the most decoration (§10.1). Filled `moss.60`/
  /// `moss.40` surface, `radius.xs`, `elevation: 0` at every state (filled
  /// color alone is enough weight — no shadow, ever). Hover/press darken
  /// one step along the same Moss scale the fill's own rest color comes
  /// from; disabled falls back to a flat Stone treatment with no
  /// interaction affordance implied. Only one variant exists because only
  /// one is a real consumer today (`AppButton` has never had a secondary/
  /// outlined mode) — §10.1's secondary-button note documents the
  /// available treatment for when a screen actually needs it, not a
  /// mandate to build it unused.
  static ElevatedButtonThemeData _elevatedButtonTheme({
    required ColorScheme colorScheme,
    required AppShapeExtension shape,
    required bool isLight,
  }) {
    final hoverColor = isLight ? VerdantColors.moss70 : VerdantColors.moss50;
    final pressColor = isLight ? VerdantColors.moss80 : VerdantColors.moss60;
    final disabledFill = isLight
        ? VerdantColors.stone30
        : VerdantColors.stone80;
    final disabledText = isLight
        ? VerdantColors.stone50
        : VerdantColors.stone50;

    return ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shape.radiusXs),
          ),
        ),
        // No textStyle override -- ElevatedButton's own default already
        // resolves to theme.textTheme.labelLarge (medium weight, §10.1's
        // "never bold"), which correctly carries the Plus Jakarta Sans
        // fontFamily. A bare TextStyle(fontWeight: ...) here replaces
        // (ButtonStyle fields don't merge) rather than layers on top of
        // that default, silently dropping the fontFamily back to the
        // platform default -- the same font-loading trap flagged after
        // the Fase 0 typeface work.
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledFill;
          if (states.contains(WidgetState.pressed)) return pressColor;
          if (states.contains(WidgetState.hovered)) return hoverColor;
          return colorScheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return disabledText;
          return colorScheme.onPrimary;
        }),
      ),
    );
  }

  /// Precision input (§10.3): `radius.xs`, `stone.30` resting border
  /// shifting to a 2px `moss.60` focus border (no glow, no shadow — the
  /// focus ring *is* the border, thickened and recolored). Error state
  /// recolors the border and helper text to `ember.60`. `AppTextField`
  /// itself renders the label as a static `Text` above the field (never
  /// `InputDecoration.labelText`, which would float) — this theme only
  /// owns the field's own chrome.
  static InputDecorationTheme _inputDecorationTheme({
    required ColorScheme colorScheme,
    required AppShapeExtension shape,
  }) {
    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(shape.radiusXs),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecorationTheme(
      border: border(colorScheme.outlineVariant),
      enabledBorder: border(colorScheme.outlineVariant),
      focusedBorder: border(colorScheme.primary, width: 2),
      errorBorder: border(colorScheme.error),
      focusedErrorBorder: border(colorScheme.error, width: 2),
      errorStyle: TextStyle(color: colorScheme.error),
    );
  }

  /// Genuine interruption — Level 3 depth, the one register where shadow
  /// is fully deployed, and `radius.md` (6px), the most rounded any
  /// Verdant surface gets by default, marking it as the exceptional
  /// floating case (§10.5). `elevation: 8` approximates the Level 3
  /// register; see `AppDialog`'s own doc comment for the motion side of
  /// this (handled per-call via `AnimationStyle`, not here).
  static DialogThemeData _dialogTheme({
    required ColorScheme colorScheme,
    required AppShapeExtension shape,
  }) {
    return DialogThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(shape.radiusMd),
      ),
    );
  }

  /// A temporary overlay (§10.6) — `radius.sm`, floating behavior (reads
  /// as a detached surface rather than a full-width fixed bar, matching
  /// the Level 3 "true overlay" register). Tone colors
  /// (`AppSnackBar.showError`/`.showSuccess`/`.showInfo`) already come
  /// from the hand-authored `ColorScheme`/`AppSemanticColors` — nothing
  /// here overrides color, only shape/elevation/behavior.
  ///
  /// `elevation: 0` deliberately, not a Level-3 oversight: Material's
  /// built-in elevation shadow renders as a hard, unblurred edge rather
  /// than the soft ambient shadow §6 specifies (visually confirmed —
  /// verified this isn't specific to SnackBar by checking the pre-existing
  /// `AppExpressiveCard`, which shows the same hard edge at its own low
  /// elevation). `AppCard` sidesteps this by painting a literal
  /// `BoxShadow` list instead of using `Card.elevation`; `SnackBar`'s
  /// shadow is internal to the widget with no equivalent hook. Floating
  /// behavior's own margin already reads as "detached from the page
  /// edges" without needing a shadow on top of it, and a harsh shadow
  /// contradicts §1's restraint more than a missing one does.
  static SnackBarThemeData _snackBarTheme({required AppShapeExtension shape}) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(shape.radiusSm),
      ),
    );
  }

  static AppSpacingExtension _scaledSpacing(double multiplier) {
    const spacing = AppSpacingExtension.standard;
    if (multiplier == 1) return spacing;
    return spacing.copyWith(
      xxxs: spacing.xxxs * multiplier,
      xxs: spacing.xxs * multiplier,
      xs: spacing.xs * multiplier,
      sm: spacing.sm * multiplier,
      md: spacing.md * multiplier,
      lg: spacing.lg * multiplier,
      xl: spacing.xl * multiplier,
      xxl: spacing.xxl * multiplier,
      xxxl: spacing.xxxl * multiplier,
      xxxxl: spacing.xxxxl * multiplier,
    );
  }

  static AppShapeExtension _scaledShape(double multiplier) {
    const shape = AppShapeExtension.standard;
    if (multiplier == 1) return shape;
    return shape.copyWith(
      radiusNone: shape.radiusNone * multiplier,
      radiusXs: shape.radiusXs * multiplier,
      radiusSm: shape.radiusSm * multiplier,
      radiusMd: shape.radiusMd * multiplier,
      radiusPill: shape.radiusPill * multiplier,
    );
  }

  static AppMotionExtension _scaledMotion(double speed) {
    const motion = AppMotionExtension.standard;
    if (speed == 1) return motion;
    return motion.copyWith(
      durationMicro: _scaled(motion.durationMicro, speed),
      durationStandard: _scaled(motion.durationStandard, speed),
      durationPanel: _scaled(motion.durationPanel, speed),
      durationPage: _scaled(motion.durationPage, speed),
    );
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

    final colorScheme = _colorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
    );
    final spacing = _scaledSpacing(spacingMultiplier);
    final shape = _scaledShape(radiusMultiplier);
    final motion = _scaledMotion(motionSpeedMultiplier);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      extensions: [
        spacing,
        AppSemanticColors.light,
        shape,
        AppElevationExtension.light,
        motion,
      ],
      elevatedButtonTheme: _elevatedButtonTheme(
        colorScheme: colorScheme,
        shape: shape,
        isLight: true,
      ),
      inputDecorationTheme: _inputDecorationTheme(
        colorScheme: colorScheme,
        shape: shape,
      ),
      dialogTheme: _dialogTheme(colorScheme: colorScheme, shape: shape),
      snackBarTheme: _snackBarTheme(shape: shape),
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

    final colorScheme = _colorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
    );
    final spacing = _scaledSpacing(spacingMultiplier);
    final shape = _scaledShape(radiusMultiplier);
    final motion = _scaledMotion(motionSpeedMultiplier);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      extensions: [
        spacing,
        AppSemanticColors.dark,
        shape,
        AppElevationExtension.dark,
        motion,
      ],
      elevatedButtonTheme: _elevatedButtonTheme(
        colorScheme: colorScheme,
        shape: shape,
        isLight: false,
      ),
      inputDecorationTheme: _inputDecorationTheme(
        colorScheme: colorScheme,
        shape: shape,
      ),
      dialogTheme: _dialogTheme(colorScheme: colorScheme, shape: shape),
      snackBarTheme: _snackBarTheme(shape: shape),
    );
  }
}
