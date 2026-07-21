import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';
import '../buttons/app_button.dart';

/// Which tone [AppStateView] renders its icon/message in.
enum AppStateViewTone { neutral, error }

/// Token-driven placeholder for a screen's non-content states — empty data,
/// labelled loading, or error+retry (icon-or-spinner + message + optional
/// action). Renamed from `AppEmptyState` (icon required, no loading/tone)
/// once evidence showed the same icon+message+action skeleton was being
/// hand-rolled for loading and error states too — `NotFoundPage`
/// (`packages/shared`) used the "empty" shape by hand before adopting this;
/// Home/Profile's error+retry and akujamin-v2's 8+ near-identical
/// error/loading screens never had a shared component at all (design
/// system component-gap audit, 2026-07-18).
@verdantStable
class AppStateView extends StatelessWidget {
  final IconData? icon;
  final bool loading;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AppStateViewTone tone;

  const AppStateView({
    super.key,
    this.icon,
    this.loading = false,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.tone = AppStateViewTone.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final markerColor = switch (tone) {
      AppStateViewTone.neutral => colorScheme.outline,
      AppStateViewTone.error => colorScheme.error,
    };
    final hasMarker = loading || icon != null;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(color: markerColor),
              )
            else if (icon != null)
              Icon(icon, size: 48, color: markerColor),
            if (hasMarker) SizedBox(height: context.spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: tone == AppStateViewTone.error
                    ? colorScheme.error
                    : null,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: context.spacing.md),
              AppButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
