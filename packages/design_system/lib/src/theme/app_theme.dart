import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing_extension.dart';
import '../tokens/app_typography.dart';

/// The only two `ThemeData` factories the app ever needs. Dynamic color
/// (Material You) is applied at the app level via `DynamicColorBuilder`,
/// falling back to this static seeded scheme when unsupported (§16).
class AppTheme {
  const AppTheme._();

  static final TextTheme _textTheme = const TextTheme(
    headlineLarge: AppTypography.headlineLarge,
    headlineMedium: AppTypography.headlineMedium,
    titleLarge: AppTypography.titleLarge,
    bodyLarge: AppTypography.bodyLarge,
    bodyMedium: AppTypography.bodyMedium,
    labelSmall: AppTypography.labelSmall,
  );

  static const List<ThemeExtension<dynamic>> _extensions = [
    AppSpacingExtension.standard,
  ];

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    textTheme: _textTheme,
    extensions: _extensions,
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsDark.primary,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme,
    extensions: _extensions,
  );
}
