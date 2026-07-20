import 'package:flutter/material.dart';

import 'verdant_colors.dart';

/// One named depth treatment (docs/VERDANT_DESIGN_SYSTEM.md §6) — border,
/// shadow, and an optional surface-tone override, instead of a single
/// Material elevation dp number. `shadow` is deliberately near-invisible
/// or empty for everything except [AppElevationExtension.floating] — most
/// of a Verdant screen lives at [AppElevationExtension.resting], which
/// has **no shadow at all**, only a hairline border.
@immutable
class AppDepthLevel {
  const AppDepthLevel({
    required this.border,
    required this.shadow,
    this.surfaceColor,
  });

  /// `null` for [AppElevationExtension.flush]/[AppElevationExtension.floating]
  /// (the latter separates from content via [shadow] + [surfaceColor]
  /// instead of a border).
  final BoxBorder? border;

  /// Empty for [AppElevationExtension.flush]/[AppElevationExtension.resting]
  /// — depth at those levels comes from [border] alone, never shadow.
  final List<BoxShadow> shadow;

  /// `null` means "render at the ambient page surface color." Only
  /// [AppElevationExtension.floating] overrides this, one Stone step
  /// lighter (light mode) / lighter-of-dark (dark mode) than the page —
  /// the surface-tone step that, combined with [shadow], marks a true
  /// overlay as detached from the content below it.
  final Color? surfaceColor;
}

/// Depth/elevation tokens.
///
/// Verdant (docs/VERDANT_DESIGN_SYSTEM.md §6) replaces Material's
/// always-on, six-level shadow scale with four named levels, each with a
/// stated reason to exist: [flush] (the page itself), [resting] (hairline
/// border, no shadow — where most of a screen lives), [lifted]
/// (interaction feedback only — hover/focus on an otherwise-resting
/// container), [floating] (true overlays: dialogs, sheets, menus — the
/// only level with real shadow by default).
///
/// `level0`–`level5` are the pre-Verdant M3 dp scale, kept **temporarily**
/// so `AppCard` (`elevation: context.elevation.level1`) keeps compiling
/// until Tahap 2 rewires it onto [resting]/[lifted] directly. Removed once
/// that migration lands, not before.
@immutable
class AppElevationExtension extends ThemeExtension<AppElevationExtension> {
  const AppElevationExtension({
    required this.flush,
    required this.resting,
    required this.lifted,
    required this.floating,
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  static const AppElevationExtension light = AppElevationExtension(
    flush: AppDepthLevel(border: null, shadow: []),
    resting: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: VerdantColors.stone20)),
      shadow: [],
    ),
    lifted: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: VerdantColors.stone20)),
      shadow: [
        BoxShadow(
          color: Color(0x0A000000), // black @ 4%
          blurRadius: 12,
          offset: Offset(0, 2),
        ),
      ],
    ),
    floating: AppDepthLevel(
      border: null,
      shadow: [
        BoxShadow(
          color: Color(0x14000000), // black @ 8%
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
      surfaceColor: VerdantColors.stone10,
    ),
    level0: 0.0,
    level1: 1.0,
    level2: 3.0,
    level3: 6.0,
    level4: 8.0,
    level5: 12.0,
  );

  static const AppElevationExtension dark = AppElevationExtension(
    flush: AppDepthLevel(border: null, shadow: []),
    resting: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: VerdantColors.stone80)),
      shadow: [],
    ),
    lifted: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: VerdantColors.stone80)),
      shadow: [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 12,
          offset: Offset(0, 2),
        ),
      ],
    ),
    floating: AppDepthLevel(
      border: null,
      shadow: [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
      surfaceColor: VerdantColors.stone95,
    ),
    level0: 0.0,
    level1: 1.0,
    level2: 3.0,
    level3: 6.0,
    level4: 8.0,
    level5: 12.0,
  );

  /// The baseline — page background itself. No border, no shadow.
  final AppDepthLevel flush;

  /// Cards, list items, containers at rest — hairline border, no shadow.
  /// Most of a Verdant screen lives here.
  final AppDepthLevel resting;

  /// Hover/focus feedback on an otherwise-resting interactive container —
  /// depth as a response to interaction, not a permanent decoration.
  final AppDepthLevel lifted;

  /// Dialogs, bottom sheets, menus, tooltips — true overlays only. The one
  /// level with real shadow by default.
  final AppDepthLevel floating;

  /// @Deprecated — pending Tahap 2 removal, see class doc.
  final double level0;

  /// @Deprecated — pending Tahap 2 removal, see class doc.
  final double level1;

  /// @Deprecated — pending Tahap 2 removal, see class doc.
  final double level2;

  /// @Deprecated — pending Tahap 2 removal, see class doc.
  final double level3;

  /// @Deprecated — pending Tahap 2 removal, see class doc.
  final double level4;

  /// @Deprecated — pending Tahap 2 removal, see class doc.
  final double level5;

  @override
  AppElevationExtension copyWith({
    AppDepthLevel? flush,
    AppDepthLevel? resting,
    AppDepthLevel? lifted,
    AppDepthLevel? floating,
    double? level0,
    double? level1,
    double? level2,
    double? level3,
    double? level4,
    double? level5,
  }) {
    return AppElevationExtension(
      flush: flush ?? this.flush,
      resting: resting ?? this.resting,
      lifted: lifted ?? this.lifted,
      floating: floating ?? this.floating,
      level0: level0 ?? this.level0,
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      level3: level3 ?? this.level3,
      level4: level4 ?? this.level4,
      level5: level5 ?? this.level5,
    );
  }

  @override
  AppElevationExtension lerp(
    ThemeExtension<AppElevationExtension>? other,
    double t,
  ) {
    if (other is! AppElevationExtension) return this;
    double l(double a, double b) => a + (b - a) * t;
    // AppDepthLevel (border/shadow/surfaceColor) has no clean linear
    // interpolation — snapped at the midpoint, same treatment this
    // package already gives non-numeric fields (e.g. AppMotionExtension's
    // curves).
    return AppElevationExtension(
      flush: t < 0.5 ? flush : other.flush,
      resting: t < 0.5 ? resting : other.resting,
      lifted: t < 0.5 ? lifted : other.lifted,
      floating: t < 0.5 ? floating : other.floating,
      level0: l(level0, other.level0),
      level1: l(level1, other.level1),
      level2: l(level2, other.level2),
      level3: l(level3, other.level3),
      level4: l(level4, other.level4),
      level5: l(level5, other.level5),
    );
  }
}
