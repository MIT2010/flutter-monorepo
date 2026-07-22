import 'package:flutter/material.dart';

import 'verdant_colors.dart';

/// Status colors `ColorScheme` doesn't cover (success/warning/info sit
/// outside M3's primary/secondary/tertiary/error roles). Each role has a
/// paired `onX` — same convention as `ColorScheme.error`/`.onError` — so a
/// consumer can use the role either as text/icon color directly on a
/// surface, or as a filled badge background with `onX` as the label color
/// on top.
///
/// Verdant values (docs/VERDANT_DESIGN_SYSTEM.md §3.3): success stays in
/// the Moss family (growth = success, thematically continuous with the
/// primary action color, one step brighter so the two read as related but
/// distinguishable), warning is Brass (aged brass fittings, not
/// traffic-cone orange), info is Mist (river water under fog). Danger
/// does NOT live here — it's `ColorScheme.error`/`.onError` (Ember),
/// consistent with how every consumer already reaches for
/// `colorScheme.error` directly rather than a semantic-colors field.
///
/// Every value below is WCAG 2.1 AA-verified (>=4.5:1) both ways — role
/// against `AppTheme`'s real `colorScheme.surface`, and `onX` against its
/// own role as a fill — in both light and dark, enforced by
/// `test/tokens/app_semantic_colors_test.dart` so a future edit that
/// breaks contrast fails the suite instead of shipping unnoticed.
///
/// [accent]/[onAccent] are the one exception to "every role is a status
/// signal" above — added alongside "the Verdant Corner" shape signature
/// (docs/VERDANT_DESIGN_SYSTEM.md's visual-identity revision) as the
/// fill for [VerdantNotchedBorder]'s cut corner on emphasis surfaces
/// (primary buttons, selected tags, active menu/dropdown items).
/// Deliberately **not** `colorScheme.secondary` — that role is already
/// hand-authored as a neutral Stone tone elsewhere in this theme, and
/// repurposing it would be a breaking semantic change for any existing
/// consumer; deliberately **not** reusing [warning] outright either, even
/// though both happen to be Brass — a decorative brand accent and a
/// warning signal sharing one hue is a coincidence of this palette having
/// only one warm secondary scale, not a claim that a notch means
/// "warning." Same brass50/brass40 tier [warning] itself uses, since
/// there's no separate spec-authored value to draw from and no reason to
/// invent one — but named and documented as its own role so the two
/// meanings don't get tangled later.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.accent,
    required this.onAccent,
    required this.chartSeries,
  });

  static const AppSemanticColors light = AppSemanticColors(
    // moss50 (VERDANT_DESIGN_SYSTEM.md §3.3's "new leaf" success tone,
    // one step brighter than moss60's primary) passes AA cleanly here --
    // verified by this file's own contrast test below, not assumed.
    success: VerdantColors.moss50,
    onSuccess: VerdantColors.stone0,
    // brass60 (the spec's originally-proposed light-mode warning) measured
    // 4.29:1 against stone0 -- short of the 4.5 AA bar, caught by this
    // file's own real contrast test, not assumed from the spec document.
    // brass70 ("warning, pressed" in the spec's own scale) is darker and
    // clears AA -- reused rather than guessing another unverified hex.
    warning: VerdantColors.brass70,
    onWarning: VerdantColors.stone0,
    info: VerdantColors.mist60,
    onInfo: VerdantColors.stone0,
    // A small decorative fill, not text -- see class doc for why this
    // isn't just `warning` reused directly.
    accent: VerdantColors.brass50,
    onAccent: VerdantColors.stone0,
    // §10.14's literal five-series order. Unlike warning/success/info
    // above, these are decorative bar/line *fills*, not text -- held to
    // WCAG's looser 3:1 non-text ("meaningful graphical object") contrast
    // bar rather than 4.5:1 text contrast, so brass60 (which failed the
    // stricter bar for `warning` above) is fine reused here at its
    // originally-spec'd tier.
    chartSeries: [
      VerdantColors.moss60,
      VerdantColors.mist60,
      VerdantColors.brass60,
      VerdantColors.ember60,
      VerdantColors.stone60,
    ],
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: VerdantColors.moss40,
    onSuccess: VerdantColors.stone98,
    warning: VerdantColors.brass40,
    onWarning: VerdantColors.stone98,
    info: VerdantColors.mist40,
    onInfo: VerdantColors.stone98,
    accent: VerdantColors.brass40,
    onAccent: VerdantColors.stone98,
    // Same *40 tier every other dark-mode saturated role already uses
    // (colorScheme.primary/error/tertiary) for consistency across modes.
    chartSeries: [
      VerdantColors.moss40,
      VerdantColors.mist40,
      VerdantColors.brass40,
      VerdantColors.ember40,
      VerdantColors.stone40,
    ],
  );

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;
  final Color accent;
  final Color onAccent;
  final List<Color> chartSeries;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    Color? accent,
    Color? onAccent,
    List<Color>? chartSeries,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
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
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      // A fixed 5-color sequence, not a smoothly-interpolatable scalar --
      // snapped at the midpoint, the same treatment this package already
      // gives other non-trivial fields (AppElevationExtension's borders/
      // shadows, AppMotionExtension's curves).
      chartSeries: t < 0.5 ? chartSeries : other.chartSeries,
    );
  }
}
