import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('light() uses Material 3 with a light brightness', () {
      final theme = AppTheme.light();

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
    });

    test('dark() uses Material 3 with a dark brightness', () {
      final theme = AppTheme.dark();

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('light()/dark() populate all 15 TextTheme slots', () {
      for (final theme in [AppTheme.light(), AppTheme.dark()]) {
        final textTheme = theme.textTheme;
        expect(textTheme.displayLarge, isNotNull);
        expect(textTheme.displayMedium, isNotNull);
        expect(textTheme.displaySmall, isNotNull);
        expect(textTheme.headlineLarge, isNotNull);
        expect(textTheme.headlineMedium, isNotNull);
        expect(textTheme.headlineSmall, isNotNull);
        expect(textTheme.titleLarge, isNotNull);
        expect(textTheme.titleMedium, isNotNull);
        expect(textTheme.titleSmall, isNotNull);
        expect(textTheme.bodyLarge, isNotNull);
        expect(textTheme.bodyMedium, isNotNull);
        expect(textTheme.bodySmall, isNotNull);
        expect(textTheme.labelLarge, isNotNull);
        expect(textTheme.labelMedium, isNotNull);
        expect(textTheme.labelSmall, isNotNull);
      }
    });

    test('light()/dark() each register every design_system ThemeExtension, '
        'with the brightness-matched AppSemanticColors', () {
      final light = AppTheme.light();
      final dark = AppTheme.dark();

      expect(
        light.extension<AppSpacingExtension>(),
        AppSpacingExtension.standard,
      );
      expect(
        dark.extension<AppSpacingExtension>(),
        AppSpacingExtension.standard,
      );
      expect(light.extension<AppSemanticColors>(), AppSemanticColors.light);
      expect(dark.extension<AppSemanticColors>(), AppSemanticColors.dark);
      expect(light.extension<AppShapeExtension>(), AppShapeExtension.standard);
      expect(dark.extension<AppShapeExtension>(), AppShapeExtension.standard);
      expect(
        light.extension<AppElevationExtension>(),
        AppElevationExtension.standard,
      );
      expect(
        dark.extension<AppElevationExtension>(),
        AppElevationExtension.standard,
      );
      expect(
        light.extension<AppMotionExtension>(),
        AppMotionExtension.standard,
      );
      expect(dark.extension<AppMotionExtension>(), AppMotionExtension.standard);
    });
  });
}
