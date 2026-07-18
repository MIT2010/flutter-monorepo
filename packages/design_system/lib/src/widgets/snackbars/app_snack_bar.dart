import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Static tone-specific `SnackBar` helpers -- 6 raw
/// `ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
/// Text(...)))` call sites in `akujamin-v2` styled every message
/// identically regardless of whether it reported failure, success, or
/// plain information (component-gap audit, 2026-07-18, see
/// ARCHITECTURE.md ADR-017). Only `error`/`success` get explicit color
/// treatment -- no `warning` variant, since no evidenced occurrence needed
/// one (docs/COMPONENT_ANATOMY.md §3).
class AppSnackBar {
  const AppSnackBar._();

  static void showError(BuildContext context, String message) {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.error,
        content: Text(message, style: TextStyle(color: colors.onError)),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    final colors = context.semanticColors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.success,
        content: Text(message, style: TextStyle(color: colors.onSuccess)),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
