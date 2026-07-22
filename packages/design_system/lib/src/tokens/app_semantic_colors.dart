import 'package:flutter/material.dart';

/// Status colors `ColorScheme` doesn't cover (success/warning/info sit
/// outside M3's primary/secondary/tertiary/error roles). Each role has a
/// paired `onX` — same convention as `ColorScheme.error`/`.onError` — so a
/// consumer can use the role either as text/icon color directly on a
/// surface, or as a filled badge background with `onX` as the label color
/// on top. Danger does NOT live here — it's `ColorScheme.error`/`.onError`.
///
/// Every value below is WCAG 2.1 AA-verified (>=4.5:1) both ways — role
/// against `AppTheme`'s real `colorScheme.surface`, and `onX` against its
/// own role as a fill — in both light and dark, enforced by
/// `test/tokens/app_semantic_colors_test.dart` so a future edit that
/// breaks contrast fails the suite instead of shipping unnoticed.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.chartSeries,
  });

  static const AppSemanticColors light = AppSemanticColors(
    success: Color(0xFF2E7D32),
    onSuccess: Colors.white,
    warning: Color(0xFF8A5300),
    onWarning: Colors.white,
    info: Color(0xFF1565C0),
    onInfo: Colors.white,
    // A controlled five-series sequence for multi-series charts, reused
    // rather than each chart component inventing its own categorical
    // palette.
    chartSeries: [
      Color(0xFF2E7D32),
      Color(0xFF1565C0),
      Color(0xFF8A5300),
      Color(0xFFC62828),
      Color(0xFF616161),
    ],
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF81C784),
    onSuccess: Colors.black,
    warning: Color(0xFFFFB74D),
    onWarning: Colors.black,
    info: Color(0xFF64B5F6),
    onInfo: Colors.black,
    chartSeries: [
      Color(0xFF81C784),
      Color(0xFF64B5F6),
      Color(0xFFFFB74D),
      Color(0xFFE57373),
      Color(0xFFBDBDBD),
    ],
  );

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;
  final List<Color> chartSeries;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    List<Color>? chartSeries,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      chartSeries: chartSeries ?? this.chartSeries,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      // A fixed 5-color sequence, not a smoothly-interpolatable scalar --
      // snapped at the midpoint, the same treatment this package already
      // gives other non-trivial fields (AppElevationExtension's borders/
      // shadows, AppMotionExtension's curves).
      chartSeries: t < 0.5 ? chartSeries : other.chartSeries,
    );
  }
}
