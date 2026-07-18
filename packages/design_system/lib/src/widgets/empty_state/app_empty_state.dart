import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';
import '../buttons/app_button.dart';

/// Token-driven "nothing here yet" placeholder (icon + message + optional
/// action) — generalizes the bespoke pattern `NotFoundPage` built by hand
/// (icon-less `Text`+`AppButton`+literal `EdgeInsets`) into a reusable
/// component any list-based feature (history, counseling, search results)
/// can share instead of re-inventing the same layout (§16 token-upgrade
/// proposal, 2026-07-17).
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
            SizedBox(height: context.spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
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
