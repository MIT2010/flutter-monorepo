import 'package:flutter/material.dart';

import '../tokens/app_spacing_extension.dart';

/// `BuildContext` accessors for every `ThemeExtension` this package
/// registers, so call sites read `context.spacing.md` instead of the more
/// verbose `Theme.of(context).extension<AppSpacingExtension>()!.md` (§16).
extension AppThemeContext on BuildContext {
  AppSpacingExtension get spacing =>
      _requireExtension<AppSpacingExtension>(this);
}

/// Every accessor above routes through this instead of a bare `!` so a
/// missing registration fails with a message that says exactly what's
/// missing and how to fix it, in both debug AND release builds — a plain
/// null-check would throw "Null check operator used on a null value" with
/// zero context, and `assert` strips out of release entirely.
T _requireExtension<T>(BuildContext context) {
  final extension = Theme.of(context).extension<T>();
  if (extension == null) {
    throw FlutterError.fromParts([
      ErrorSummary('$T not found in ThemeData.extensions.'),
      ErrorDescription(
        'This design system\'s BuildContext accessors (context.spacing, '
        'context.semanticColors, etc.) require every design_system '
        'ThemeExtension to be present on the ThemeData in scope.',
      ),
      ErrorHint(
        'Add $T to the `extensions` list passed to ThemeData(...) — see '
        'AppTheme.light()/AppTheme.dark(). If you reached this from a '
        'custom Theme(...) override further down the tree, make sure it '
        'copies `extensions` from the ambient theme rather than starting '
        'ThemeData from scratch.',
      ),
    ]);
  }
  return extension;
}
