import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSpacingExtension', () {
    test('standard scale is strictly increasing', () {
      const spacing = AppSpacingExtension.standard;
      expect(spacing.xxxs, lessThan(spacing.xxs));
      expect(spacing.xxs, lessThan(spacing.xs));
      expect(spacing.xs, lessThan(spacing.sm));
      expect(spacing.sm, lessThan(spacing.md));
      expect(spacing.md, lessThan(spacing.lg));
      expect(spacing.lg, lessThan(spacing.xl));
      expect(spacing.xl, lessThan(spacing.xxl));
      expect(spacing.xxl, lessThan(spacing.xxxl));
      expect(spacing.xxxl, lessThan(spacing.xxxxl));
    });

    test('copyWith overrides only the given fields', () {
      const spacing = AppSpacingExtension.standard;
      final copy = spacing.copyWith(md: 20.0);

      expect(copy.md, 20.0);
      expect(copy.xxxs, spacing.xxxs);
      expect(copy.xxs, spacing.xxs);
      expect(copy.xs, spacing.xs);
      expect(copy.sm, spacing.sm);
      expect(copy.lg, spacing.lg);
      expect(copy.xl, spacing.xl);
      expect(copy.xxl, spacing.xxl);
      expect(copy.xxxl, spacing.xxxl);
      expect(copy.xxxxl, spacing.xxxxl);
    });

    test('lerp interpolates every field linearly', () {
      const a = AppSpacingExtension(
        xxxs: 0,
        xxs: 0,
        xs: 0,
        sm: 0,
        md: 0,
        lg: 0,
        xl: 0,
        xxl: 0,
        xxxl: 0,
        xxxxl: 0,
      );
      const b = AppSpacingExtension(
        xxxs: 10,
        xxs: 10,
        xs: 10,
        sm: 10,
        md: 10,
        lg: 10,
        xl: 10,
        xxl: 10,
        xxxl: 10,
        xxxxl: 10,
      );

      final mid = a.lerp(b, 0.5);

      expect(mid.xxxs, 5.0);
      expect(mid.xs, 5.0);
      expect(mid.md, 5.0);
      expect(mid.xl, 5.0);
      expect(mid.xxxxl, 5.0);
    });

    test('lerp returns this unchanged when other is a different type', () {
      const spacing = AppSpacingExtension.standard;
      // ThemeExtension<T>.lerp receives ThemeExtension<T>? from the
      // framework, which in practice is always the same concrete type —
      // this guards the defensive `is! AppSpacingExtension` branch.
      final result = spacing.lerp(null, 0.5);
      expect(result, spacing);
    });
  });
}
