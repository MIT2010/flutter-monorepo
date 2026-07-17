import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.1 contrast ratio between two colors, using [Color.computeLuminance]
/// (already the WCAG relative-luminance formula) — no external package
/// needed for math this small and stable.
double _contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

const _wcagAA = 4.5;

void main() {
  group('AppSemanticColors WCAG AA contrast', () {
    // Verified against the REAL runtime ColorScheme.surface AppTheme
    // produces (ColorScheme.fromSeed's derived tone), not an assumed
    // hex value — this is what a role would actually sit on if used as
    // plain text/icon color with no fill behind it.
    final lightSurface = AppTheme.light().colorScheme.surface;
    final darkSurface = AppTheme.dark().colorScheme.surface;

    test(
      'light: success/warning/info are >=4.5:1 against colorScheme.surface',
      () {
        const colors = AppSemanticColors.light;
        expect(
          _contrastRatio(colors.success, lightSurface),
          greaterThanOrEqualTo(_wcagAA),
        );
        expect(
          _contrastRatio(colors.warning, lightSurface),
          greaterThanOrEqualTo(_wcagAA),
        );
        expect(
          _contrastRatio(colors.info, lightSurface),
          greaterThanOrEqualTo(_wcagAA),
        );
      },
    );

    test(
      'dark: success/warning/info are >=4.5:1 against colorScheme.surface',
      () {
        const colors = AppSemanticColors.dark;
        expect(
          _contrastRatio(colors.success, darkSurface),
          greaterThanOrEqualTo(_wcagAA),
        );
        expect(
          _contrastRatio(colors.warning, darkSurface),
          greaterThanOrEqualTo(_wcagAA),
        );
        expect(
          _contrastRatio(colors.info, darkSurface),
          greaterThanOrEqualTo(_wcagAA),
        );
      },
    );

    test('light: onSuccess/onWarning/onInfo are >=4.5:1 against their own '
        'role used as a filled badge background', () {
      const colors = AppSemanticColors.light;
      expect(
        _contrastRatio(colors.onSuccess, colors.success),
        greaterThanOrEqualTo(_wcagAA),
      );
      expect(
        _contrastRatio(colors.onWarning, colors.warning),
        greaterThanOrEqualTo(_wcagAA),
      );
      expect(
        _contrastRatio(colors.onInfo, colors.info),
        greaterThanOrEqualTo(_wcagAA),
      );
    });

    test('dark: onSuccess/onWarning/onInfo are >=4.5:1 against their own '
        'role used as a filled badge background', () {
      const colors = AppSemanticColors.dark;
      expect(
        _contrastRatio(colors.onSuccess, colors.success),
        greaterThanOrEqualTo(_wcagAA),
      );
      expect(
        _contrastRatio(colors.onWarning, colors.warning),
        greaterThanOrEqualTo(_wcagAA),
      );
      expect(
        _contrastRatio(colors.onInfo, colors.info),
        greaterThanOrEqualTo(_wcagAA),
      );
    });
  });

  group('AppSemanticColors', () {
    test('copyWith overrides only the given fields', () {
      const colors = AppSemanticColors.light;
      final copy = colors.copyWith(success: const Color(0xFF000000));

      expect(copy.success, const Color(0xFF000000));
      expect(copy.onSuccess, colors.onSuccess);
      expect(copy.warning, colors.warning);
      expect(copy.info, colors.info);
    });

    test('lerp interpolates between light and dark', () {
      final mid = AppSemanticColors.light.lerp(AppSemanticColors.dark, 0.5);
      expect(mid.success, isNot(AppSemanticColors.light.success));
      expect(mid.success, isNot(AppSemanticColors.dark.success));
    });

    test('lerp returns this unchanged when other is a different type', () {
      const colors = AppSemanticColors.light;
      final result = colors.lerp(null, 0.5);
      expect(result, colors);
    });
  });
}
