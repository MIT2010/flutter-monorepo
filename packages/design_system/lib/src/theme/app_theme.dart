import 'package:flutter/material.dart';

import '../tokens/app_elevation_extension.dart';
import '../tokens/app_motion_extension.dart';
import '../tokens/app_semantic_colors.dart';
import '../tokens/app_shape_extension.dart';
import '../tokens/app_spacing_extension.dart';

/// The only two `ThemeData` factories the app ever needs.
///
/// `ColorScheme.fromSeed` derives every role (primary, secondary, tertiary,
/// error, surface, outline, ...) from a single seed color, so a caller
/// wanting a different accent only ever needs to pass a new [primaryColor],
/// no other code changes.
///
/// Component-level `ThemeData` fields (`elevatedButtonTheme`,
/// `inputDecorationTheme`, `dialogTheme`, `snackBarTheme`) carry each
/// component's shape/depth decisions so `AppButton`/`AppTextField`/
/// `AppDialog`/`AppSnackBar` stay thin, theme-driven wrappers.
class AppTheme {
  const AppTheme._();

  static const Color _seedColor = Colors.deepPurple;

  /// Full 15-slot M3 type scale (Display/Headline/Title/Body/Label ×
  /// Large/Medium/Small), inlined here rather than kept in a separate
  /// public `AppTypography` class.
  static const TextTheme _baseTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  );

  /// Plus Jakarta Sans (SIL OFL 1.1, bundled locally under `fonts/` -- see
  /// `fonts/OFL.txt` -- variable `wght` axis 200-800, true per-weight
  /// italics) applied over [_baseTextTheme]. Bundled rather than fetched at
  /// runtime (e.g. via `google_fonts`) so theme construction stays a pure,
  /// synchronous, offline operation -- no network dependency in tests or on
  /// a user's first launch.
  static final TextTheme _textTheme = _baseTextTheme.apply(
    fontFamily: 'Plus Jakarta Sans',
  );

  /// Precision input: `radius.xs`, a resting outline border that thickens
  /// and recolors to `colorScheme.primary` on focus (no glow, no shadow --
  /// the focus ring *is* the border). Error state recolors the border and
  /// helper text to `colorScheme.error`. `AppTextField` itself renders the
  /// label as a static `Text` above the field (never
  /// `InputDecoration.labelText`, which would float) -- this theme only
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
      // A leading icon (e.g. AppSearchField's magnifying glass) recolors
      // with focus for the same reason the border itself does -- so the
      // icon and border always agree about focus state.
      prefixIconColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.focused)
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Flat filled surface, `radius.xs`, `elevation: 0` at every state --
  /// filled color alone is enough weight, no shadow. Hover/press darken the
  /// fill slightly; disabled uses the standard M3 `onSurface` @ 12%/38%
  /// formula rather than a bespoke palette.
  static ElevatedButtonThemeData _elevatedButtonTheme({
    required ColorScheme colorScheme,
    required AppShapeExtension shape,
  }) {
    final hoverColor = Color.lerp(colorScheme.primary, Colors.black, 0.08)!;
    final pressColor = Color.lerp(colorScheme.primary, Colors.black, 0.16)!;

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
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.pressed)) return pressColor;
          if (states.contains(WidgetState.hovered)) return hoverColor;
          return colorScheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return colorScheme.onPrimary;
        }),
      ),
    );
  }

  /// Genuine interruption -- Level 3 depth, the one register where shadow
  /// is fully deployed, `radius.md`.
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

  /// A temporary overlay -- `radius.sm`, floating behavior. Tone colors
  /// (`AppSnackBar.showError`/`.showSuccess`/`.showInfo`) already come from
  /// `ColorScheme`/`AppSemanticColors` -- nothing here overrides color,
  /// only shape/elevation/behavior. `elevation: 0` deliberately: Material's
  /// built-in elevation shadow renders as a hard, unblurred edge; floating
  /// behavior's own margin already reads as "detached from the page edges"
  /// without needing a shadow on top of it.
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
  /// input to a spring simulation.
  static Duration _scaled(Duration base, double speed) {
    return Duration(microseconds: (base.inMicroseconds / speed).round());
  }

  /// [primaryColor] overrides the seed color `ColorScheme.fromSeed` derives
  /// every role from -- defaults to [_seedColor] when omitted.
  /// [spacingMultiplier]/[radiusMultiplier]/[motionSpeedMultiplier] default
  /// to `1` (no change). These overrides exist so a caller can live-preview
  /// token changes through the same construction real screens use, rather
  /// than maintaining a second, duplicate theme recipe that could drift out
  /// of sync.
  static ThemeData light({
    Color? primaryColor,
    double spacingMultiplier = 1,
    double radiusMultiplier = 1,
    double motionSpeedMultiplier = 1,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor ?? _seedColor,
      brightness: Brightness.light,
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
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor ?? _seedColor,
      brightness: Brightness.dark,
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
