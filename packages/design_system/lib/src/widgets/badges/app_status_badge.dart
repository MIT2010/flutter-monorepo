import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Which [AppSemanticColors] role an [AppStatusBadge] renders with.
enum AppStatusTone { success, warning, info }

/// Token-driven status pill (fill + optional icon + label) — replaces the
/// ad-hoc `colorScheme.error`/`.primary` swaps and page-local `_StepDot`
/// classes seen scattered across step indicators and status displays with
/// one reusable, WCAG-AA-contrast-verified component (§16 token-upgrade
/// proposal, 2026-07-17 — first real consumer of [AppSemanticColors]).
class AppStatusBadge extends StatelessWidget {
  final String label;
  final AppStatusTone tone;
  final IconData? icon;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.tone,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.semanticColors;
    final (Color background, Color foreground) = switch (tone) {
      AppStatusTone.success => (colors.success, colors.onSuccess),
      AppStatusTone.warning => (colors.warning, colors.onWarning),
      AppStatusTone.info => (colors.info, colors.onInfo),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.shape.radiusPill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: foreground),
              SizedBox(width: context.spacing.xs),
            ],
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
