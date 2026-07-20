import 'package:flutter/material.dart';

/// Corner-radius scale.
///
/// Verdant (docs/VERDANT_DESIGN_SYSTEM.md §5): corners are precise, not
/// soft — the opposite of Material's generously-rounded default posture.
/// `radiusNone`/`radiusXs`/`radiusSm`/`radiusMd` are the new Verdant
/// scale (0/2/4/6), `radiusPill` is unchanged (still reserved for true
/// pill objects — tags, badges — never buttons/cards by default).
///
/// `radiusLg` and [expressive] are kept at their pre-Verdant values
/// **temporarily** — `AppBottomSheet` (Tahap 2, VERDANT_DESIGN_SYSTEM.md
/// §10.5) and `AppExpressiveCard` (Tahap 3, §5.4 — shape-morph is being
/// retired entirely) still reference them and are explicitly out of
/// scope for Tahap 1 (tokens only). Both fields are removed once those
/// components are redesigned in their own stage, not before.
@immutable
class AppShapeExtension extends ThemeExtension<AppShapeExtension> {
  const AppShapeExtension({
    required this.radiusNone,
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusPill,
    required this.expressive,
  });

  static const AppShapeExtension standard = AppShapeExtension(
    radiusNone: 0.0,
    radiusXs: 2.0,
    radiusSm: 4.0,
    radiusMd: 6.0,
    radiusLg: 16.0,
    radiusPill: 999.0,
    expressive: BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(8.0),
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(24.0),
    ),
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

  /// Pending Tahap 2 (`AppBottomSheet` redesign) — see class doc.
  final double radiusLg;

  /// Large enough to fully round any component shorter than this value —
  /// for pill-shaped buttons/badges/chips.
  final double radiusPill;

  /// Pending Tahap 3 (`AppExpressiveCard` retirement) — see class doc.
  final BorderRadius expressive;

  @override
  AppShapeExtension copyWith({
    double? radiusNone,
    double? radiusXs,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusPill,
    BorderRadius? expressive,
  }) {
    return AppShapeExtension(
      radiusNone: radiusNone ?? this.radiusNone,
      radiusXs: radiusXs ?? this.radiusXs,
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
      radiusNone: _lerpDouble(radiusNone, other.radiusNone, t),
      radiusXs: _lerpDouble(radiusXs, other.radiusXs, t),
      radiusSm: _lerpDouble(radiusSm, other.radiusSm, t),
      radiusMd: _lerpDouble(radiusMd, other.radiusMd, t),
      radiusLg: _lerpDouble(radiusLg, other.radiusLg, t),
      radiusPill: _lerpDouble(radiusPill, other.radiusPill, t),
      expressive: BorderRadius.lerp(expressive, other.expressive, t)!,
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
