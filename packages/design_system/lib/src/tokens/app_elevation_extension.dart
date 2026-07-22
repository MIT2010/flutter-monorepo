import 'package:flutter/material.dart';

/// One named depth treatment — border, shadow, and an optional
/// surface-tone override, instead of a single Material elevation dp
/// number. `shadow` is deliberately near-invisible or empty for
/// everything except [AppElevationExtension.floating] — most of a screen
/// lives at [AppElevationExtension.resting], which has **no shadow at
/// all**, only a hairline border.
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
  /// [AppElevationExtension.floating] overrides this, one tone step
  /// lighter than the page in either mode — the surface-tone step that,
  /// combined with [shadow], marks a true overlay as detached from the
  /// content below it.
  final Color? surfaceColor;
}

/// Depth/elevation tokens.
///
/// Replaces Material's always-on, six-level shadow scale with four named
/// levels, each with a stated reason to exist: [flush] (the page itself),
/// [resting] (hairline
/// border, no shadow — where most of a screen lives), [lifted]
/// (interaction feedback only — hover/focus on an otherwise-resting
/// container), [floating] (true overlays: dialogs, sheets, menus — the
/// only level with real shadow by default).
@immutable
class AppElevationExtension extends ThemeExtension<AppElevationExtension> {
  const AppElevationExtension({
    required this.flush,
    required this.resting,
    required this.lifted,
    required this.floating,
  });

  static const AppElevationExtension light = AppElevationExtension(
    flush: AppDepthLevel(border: null, shadow: []),
    resting: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: Color(0xFFE0E0E0))),
      shadow: [],
    ),
    lifted: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: Color(0xFFE0E0E0))),
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
      surfaceColor: Color(0xFFF5F5F5),
    ),
  );

  static const AppElevationExtension dark = AppElevationExtension(
    flush: AppDepthLevel(border: null, shadow: []),
    resting: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: Color(0xFF616161))),
      shadow: [],
    ),
    lifted: AppDepthLevel(
      border: Border.fromBorderSide(BorderSide(color: Color(0xFF616161))),
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
      surfaceColor: Color(0xFF2C2C2C),
    ),
  );

  /// The baseline — page background itself. No border, no shadow.
  final AppDepthLevel flush;

  /// Cards, list items, containers at rest — hairline border, no shadow.
  /// Most of a screen lives here.
  final AppDepthLevel resting;

  /// Hover/focus feedback on an otherwise-resting interactive container —
  /// depth as a response to interaction, not a permanent decoration.
  final AppDepthLevel lifted;

  /// Dialogs, bottom sheets, menus, tooltips — true overlays only. The one
  /// level with real shadow by default.
  final AppDepthLevel floating;

  @override
  AppElevationExtension copyWith({
    AppDepthLevel? flush,
    AppDepthLevel? resting,
    AppDepthLevel? lifted,
    AppDepthLevel? floating,
  }) {
    return AppElevationExtension(
      flush: flush ?? this.flush,
      resting: resting ?? this.resting,
      lifted: lifted ?? this.lifted,
      floating: floating ?? this.floating,
    );
  }

  @override
  AppElevationExtension lerp(
    ThemeExtension<AppElevationExtension>? other,
    double t,
  ) {
    if (other is! AppElevationExtension) return this;
    // AppDepthLevel (border/shadow/surfaceColor) has no clean linear
    // interpolation — snapped at the midpoint, same treatment this
    // package already gives non-numeric fields (e.g. AppMotionExtension's
    // curves).
    return AppElevationExtension(
      flush: t < 0.5 ? flush : other.flush,
      resting: t < 0.5 ? resting : other.resting,
      lifted: t < 0.5 ? lifted : other.lifted,
      floating: t < 0.5 ? floating : other.floating,
    );
  }
}
