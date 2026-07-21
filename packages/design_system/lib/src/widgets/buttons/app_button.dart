import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// Wraps [ElevatedButton] with the design tokens applied and owns its own
/// loading-spinner-replaces-label behavior, so every screen gets consistent
/// loading UI for free instead of scattering
/// `if (state is Loading) CircularProgressIndicator()` (§16, §23).
@verdantStable
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              height: 18,
              width: 18,
              // Explicit onPrimary color -- the default spinner color
              // resolves to colorScheme.primary, which is illegible on
              // Verdant's filled-moss button surface (Section 10.1).
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : icon == null
          ? Text(label)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                SizedBox(width: context.spacing.xs),
                Text(label),
              ],
            ),
    );
  }
}
