import 'package:flutter/material.dart';

/// Corner-radius scale, including one deliberately non-uniform preset
/// ([expressive]) for components that want a less generic, more
/// "M3 Expressive"-flavored silhouette than a plain rounded rectangle —
/// implemented with stable native `BorderRadius`, not the m3e_design
/// package (still 0.1.0, not a core-kit dependency; see the design_system
/// token-upgrade proposal, 2026-07-17).
@immutable
class AppShapeExtension extends ThemeExtension<AppShapeExtension> {
  const AppShapeExtension({
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusPill,
    required this.expressive,
  });

  static const AppShapeExtension standard = AppShapeExtension(
    radiusSm: 8.0,
    radiusMd: 12.0,
    radiusLg: 16.0,
    radiusPill: 999.0,
    expressive: BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(8.0),
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(24.0),
    ),
  );

  final double radiusSm;
  final double radiusMd;
  final double radiusLg;

  /// Large enough to fully round any component shorter than this value —
  /// for pill-shaped buttons/badges/chips.
  final double radiusPill;

  /// Non-uniform corners (large diagonal pair, small diagonal pair) — the
  /// "expressive shape" token category from the upgrade proposal.
  final BorderRadius expressive;

  @override
  AppShapeExtension copyWith({
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusPill,
    BorderRadius? expressive,
  }) {
    return AppShapeExtension(
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusPill: radiusPill ?? this.radiusPill,
      expressive: expressive ?? this.expressive,
    );
  }

  @override
  AppShapeExtension lerp(ThemeExtension<AppShapeExtension>? other, double t) {
    if (other is! AppShapeExtension) return this;
    return AppShapeExtension(
      radiusSm: _lerpDouble(radiusSm, other.radiusSm, t),
      radiusMd: _lerpDouble(radiusMd, other.radiusMd, t),
      radiusLg: _lerpDouble(radiusLg, other.radiusLg, t),
      radiusPill: _lerpDouble(radiusPill, other.radiusPill, t),
      expressive: BorderRadius.lerp(expressive, other.expressive, t)!,
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
