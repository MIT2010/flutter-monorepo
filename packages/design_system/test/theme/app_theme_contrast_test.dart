import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.1 contrast ratio between two colors, using [Color.computeLuminance]
/// (already the WCAG relative-luminance formula) — no external package
/// needed for math this small and stable. Same helper
/// `test/tokens/app_semantic_colors_test.dart` already uses.
double _contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

const _wcagAA = 4.5;

/// Every `on-X`/`X` role pair in `AppTheme`'s `ColorScheme`, checked
/// against the REAL runtime theme output. A future edit that breaks
/// contrast fails this suite instead of shipping unnoticed.
void main() {
  group('AppTheme ColorScheme WCAG AA contrast', () {
    final light = AppTheme.light().colorScheme;
    final dark = AppTheme.dark().colorScheme;

    void expectAA(String label, Color a, Color b) {
      expect(
        _contrastRatio(a, b),
        greaterThanOrEqualTo(_wcagAA),
        reason: '$label should be >=4.5:1, got ${_contrastRatio(a, b)}',
      );
    }

    test('light: every on-X role clears AA against its X role', () {
      expectAA('onPrimary/primary', light.onPrimary, light.primary);
      expectAA(
        'onPrimaryContainer/primaryContainer',
        light.onPrimaryContainer,
        light.primaryContainer,
      );
      expectAA('onSecondary/secondary', light.onSecondary, light.secondary);
      expectAA(
        'onSecondaryContainer/secondaryContainer',
        light.onSecondaryContainer,
        light.secondaryContainer,
      );
      expectAA('onTertiary/tertiary', light.onTertiary, light.tertiary);
      expectAA(
        'onTertiaryContainer/tertiaryContainer',
        light.onTertiaryContainer,
        light.tertiaryContainer,
      );
      expectAA('onError/error', light.onError, light.error);
      expectAA(
        'onErrorContainer/errorContainer',
        light.onErrorContainer,
        light.errorContainer,
      );
      expectAA('onSurface/surface', light.onSurface, light.surface);
      expectAA(
        'onSurfaceVariant/surface',
        light.onSurfaceVariant,
        light.surface,
      );
      expectAA(
        'onInverseSurface/inverseSurface',
        light.onInverseSurface,
        light.inverseSurface,
      );
    });

    test('dark: every on-X role clears AA against its X role', () {
      expectAA('onPrimary/primary', dark.onPrimary, dark.primary);
      expectAA(
        'onPrimaryContainer/primaryContainer',
        dark.onPrimaryContainer,
        dark.primaryContainer,
      );
      expectAA('onSecondary/secondary', dark.onSecondary, dark.secondary);
      expectAA(
        'onSecondaryContainer/secondaryContainer',
        dark.onSecondaryContainer,
        dark.secondaryContainer,
      );
      expectAA('onTertiary/tertiary', dark.onTertiary, dark.tertiary);
      expectAA(
        'onTertiaryContainer/tertiaryContainer',
        dark.onTertiaryContainer,
        dark.tertiaryContainer,
      );
      expectAA('onError/error', dark.onError, dark.error);
      expectAA(
        'onErrorContainer/errorContainer',
        dark.onErrorContainer,
        dark.errorContainer,
      );
      expectAA('onSurface/surface', dark.onSurface, dark.surface);
      expectAA('onSurfaceVariant/surface', dark.onSurfaceVariant, dark.surface);
      expectAA(
        'onInverseSurface/inverseSurface',
        dark.onInverseSurface,
        dark.inverseSurface,
      );
    });

    test('light()/dark() primaryColor override keeps onPrimary readable for an '
        'arbitrary chosen color', () {
      // A bright, light color -- needs dark onPrimary text.
      final withBrightOverride = AppTheme.light(
        primaryColor: const Color(0xFFEFEFE0),
      ).colorScheme;
      expectAA(
        'onPrimary/primary (bright override)',
        withBrightOverride.onPrimary,
        withBrightOverride.primary,
      );

      // A near-black color -- needs light onPrimary text.
      final withDarkOverride = AppTheme.light(
        primaryColor: const Color(0xFF0A0A0A),
      ).colorScheme;
      expectAA(
        'onPrimary/primary (dark override)',
        withDarkOverride.onPrimary,
        withDarkOverride.primary,
      );
    });
  });
}
