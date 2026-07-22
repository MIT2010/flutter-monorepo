import 'package:flutter/material.dart';

/// Corner-radius scale.
///
/// Verdant (docs/VERDANT_DESIGN_SYSTEM.md §5): corners are precise, not
/// soft — the opposite of Material's generously-rounded default posture.
/// `radiusNone`/`radiusXs`/`radiusSm`/`radiusMd` are the Verdant scale
/// (0/2/4/6), `radiusPill` is reserved for true pill objects — tags,
/// badges — never buttons/cards by default. Every corner of a surface
/// uses the same tier uniformly (docs/VERDANT_DESIGN_SYSTEM.md §16
/// revision note: an earlier revision chamfered the top-right corner of
/// every rectangle-family surface as a distinct shape signature — reverted
/// after review, corners are plain and uniform again).
@immutable
class AppShapeExtension extends ThemeExtension<AppShapeExtension> {
  const AppShapeExtension({
    required this.radiusNone,
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusPill,
  });

  static const AppShapeExtension standard = AppShapeExtension(
    radiusNone: 0.0,
    radiusXs: 2.0,
    radiusSm: 4.0,
    radiusMd: 6.0,
    radiusPill: 999.0,
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

  @override
  AppShapeExtension copyWith({
    double? radiusNone,
    double? radiusXs,
    double? radiusSm,
    double? radiusMd,
    double? radiusPill,
  }) {
    return AppShapeExtension(
      radiusNone: radiusNone ?? this.radiusNone,
      radiusXs: radiusXs ?? this.radiusXs,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusPill: radiusPill ?? this.radiusPill,
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
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
