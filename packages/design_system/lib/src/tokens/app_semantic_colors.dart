import 'package:flutter/material.dart';

/// Status colors `ColorScheme` doesn't cover (success/warning/info sit
/// outside M3's primary/secondary/tertiary/error roles). Each role has a
/// paired `onX` — same convention as `ColorScheme.error`/`.onError` — so a
/// consumer can use the role either as text/icon color directly on a
/// surface, or as a filled badge background with `onX` as the label color
/// on top.
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
  });

  static const AppSemanticColors light = AppSemanticColors(
    success: Color(0xFF1B5E20),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFF8A5300),
    onWarning: Color(0xFFFFFFFF),
    info: Color(0xFF1565C0),
    onInfo: Color(0xFFFFFFFF),
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF81C784),
    onSuccess: Color(0xFF000000),
    warning: Color(0xFFFFD54F),
    onWarning: Color(0xFF000000),
    info: Color(0xFF90CAF9),
    onInfo: Color(0xFF000000),
  );

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
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
    );
  }
}
