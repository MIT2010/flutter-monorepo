import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Wraps [ElevatedButton] with the design tokens applied and owns its own
/// loading-spinner-replaces-label behavior, so every screen gets consistent
/// loading UI for free instead of scattering
/// `if (state is Loading) CircularProgressIndicator()` (§16, §23).
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
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      // `onPressed: null` above makes ElevatedButton report itself
      // disabled, which by default also repaints the whole button in the
      // theme's disabled palette (a pale Stone fill) -- fine for a truly
      // unavailable action, wrong for "processing," which should still
      // read as the same active, branded surface. This override pins
      // background/foreground back to the primary-filled look
      // specifically while loading, so the spinner's onPrimary color
      // (chosen for legibility against that surface, see below) is never
      // painted against the low-contrast disabled fill it was found
      // silently falling back to.
      style: loading
          ? ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
              foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
            )
          : null,
      child: loading
          ? SizedBox(
              height: 18,
              width: 18,
              // Explicit onPrimary color -- the default spinner color
              // resolves to colorScheme.primary, which is illegible on
              // this button's own filled surface.
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimary,
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
