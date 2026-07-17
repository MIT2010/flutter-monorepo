import 'package:flutter/material.dart';

/// Material 3's official elevation scale (0/1/3/6/8/12dp) — sourced from
/// the M3 spec rather than invented values, so components using this
/// token stay visually consistent with M3 built-ins' own tonal-elevation
/// behavior (`Card`, `AppBar`, `NavigationBar`, etc. all snap to these
/// same six levels internally).
@immutable
class AppElevationExtension extends ThemeExtension<AppElevationExtension> {
  const AppElevationExtension({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  static const AppElevationExtension standard = AppElevationExtension(
    level0: 0.0,
    level1: 1.0,
    level2: 3.0,
    level3: 6.0,
    level4: 8.0,
    level5: 12.0,
  );

  final double level0;
  final double level1;
  final double level2;
  final double level3;
  final double level4;
  final double level5;

  @override
  AppElevationExtension copyWith({
    double? level0,
    double? level1,
    double? level2,
    double? level3,
    double? level4,
    double? level5,
  }) {
    return AppElevationExtension(
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
    return AppElevationExtension(
      level0: l(level0, other.level0),
      level1: l(level1, other.level1),
      level2: l(level2, other.level2),
      level3: l(level3, other.level3),
      level4: l(level4, other.level4),
      level5: l(level5, other.level5),
    );
  }
}
