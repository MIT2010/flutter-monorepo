import 'package:flutter/material.dart';

/// Corner-radius scale.
///
/// Verdant (docs/VERDANT_DESIGN_SYSTEM.md §5): corners are precise, not
/// soft — the opposite of Material's generously-rounded default posture.
/// `radiusNone`/`radiusXs`/`radiusSm`/`radiusMd` are the Verdant scale
/// (0/2/4/6), `radiusPill` is reserved for true pill objects — tags,
/// badges — never buttons/cards by default.
///
/// `notchXs`/`notchSm`/`notchMd` size "the Verdant Corner" (see
/// [VerdantNotchedBorder]/[VerdantNotchedInputBorder]) — the top-right
/// chamfer every rectangle-family surface now carries, sized to the same
/// tier as that surface's own `radius*`, so a `radiusXs` button and its
/// notch read as one deliberate scale rather than two unrelated numbers.
/// No `notchPill`/`notchNone`: pill surfaces don't take the notch at all
/// (see the class doc on [VerdantNotchedBorder]), and `radiusNone`
/// surfaces (data tables, dividers) have no reason to gain one either.
@immutable
class AppShapeExtension extends ThemeExtension<AppShapeExtension> {
  const AppShapeExtension({
    required this.radiusNone,
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusPill,
    required this.notchXs,
    required this.notchSm,
    required this.notchMd,
  });

  static const AppShapeExtension standard = AppShapeExtension(
    radiusNone: 0.0,
    radiusXs: 2.0,
    radiusSm: 4.0,
    radiusMd: 6.0,
    radiusPill: 999.0,
    notchXs: 6.0,
    notchSm: 10.0,
    notchMd: 14.0,
  );

  /// Absolute precision — data tables, code/monospace blocks, dividers.
  final double radiusNone;

  /// Hairline-soft, barely perceptible — default for inputs, list rows,
  /// small controls.
  final double radiusXs;

  /// Quiet, composed — cards, containers, dialogs at rest.
  final double radiusSm;

  /// Slightly lifted — elevated/floating surfaces (menus, popovers).
  final double radiusMd;

  /// Large enough to fully round any component shorter than this value —
  /// for pill-shaped buttons/badges/chips.
  final double radiusPill;

  /// Notch tier paired with [radiusXs] — inputs, tags, small controls.
  final double notchXs;

  /// Notch tier paired with [radiusSm] — cards, containers, buttons.
  final double notchSm;

  /// Notch tier paired with [radiusMd] — elevated/floating surfaces.
  final double notchMd;

  @override
  AppShapeExtension copyWith({
    double? radiusNone,
    double? radiusXs,
    double? radiusSm,
    double? radiusMd,
    double? radiusPill,
    double? notchXs,
    double? notchSm,
    double? notchMd,
  }) {
    return AppShapeExtension(
      radiusNone: radiusNone ?? this.radiusNone,
      radiusXs: radiusXs ?? this.radiusXs,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusPill: radiusPill ?? this.radiusPill,
      notchXs: notchXs ?? this.notchXs,
      notchSm: notchSm ?? this.notchSm,
      notchMd: notchMd ?? this.notchMd,
    );
  }

  @override
  AppShapeExtension lerp(ThemeExtension<AppShapeExtension>? other, double t) {
    if (other is! AppShapeExtension) return this;
    return AppShapeExtension(
      radiusNone: _lerpDouble(radiusNone, other.radiusNone, t),
      radiusXs: _lerpDouble(radiusXs, other.radiusXs, t),
      radiusSm: _lerpDouble(radiusSm, other.radiusSm, t),
      radiusMd: _lerpDouble(radiusMd, other.radiusMd, t),
      radiusPill: _lerpDouble(radiusPill, other.radiusPill, t),
      notchXs: _lerpDouble(notchXs, other.notchXs, t),
      notchSm: _lerpDouble(notchSm, other.notchSm, t),
      notchMd: _lerpDouble(notchMd, other.notchMd, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
