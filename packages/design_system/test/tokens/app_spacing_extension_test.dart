import 'package:design_system/design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSpacingExtension', () {
    test('standard scale is strictly increasing', () {
      const spacing = AppSpacingExtension.standard;
      expect(spacing.xs, lessThan(spacing.sm));
      expect(spacing.sm, lessThan(spacing.md));
      expect(spacing.md, lessThan(spacing.lg));
      expect(spacing.lg, lessThan(spacing.xl));
    });

    test('copyWith overrides only the given fields', () {
      const spacing = AppSpacingExtension.standard;
      final copy = spacing.copyWith(md: 20.0);

      expect(copy.md, 20.0);
      expect(copy.xs, spacing.xs);
      expect(copy.sm, spacing.sm);
      expect(copy.lg, spacing.lg);
      expect(copy.xl, spacing.xl);
    });

    test('lerp interpolates every field linearly', () {
      const a = AppSpacingExtension(xs: 0, sm: 0, md: 0, lg: 0, xl: 0);
      const b = AppSpacingExtension(xs: 10, sm: 10, md: 10, lg: 10, xl: 10);

      final mid = a.lerp(b, 0.5);

      expect(mid.xs, 5.0);
      expect(mid.md, 5.0);
      expect(mid.xl, 5.0);
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
