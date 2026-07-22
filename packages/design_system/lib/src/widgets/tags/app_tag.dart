import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// A user-manipulable label — filterable, removable, sometimes toggleable
/// (§10.15). Distinct from [AppStatusBadge]: **Tag** is input/interactive,
/// appearing in forms/filters/search contexts; **Badge** is a read-only
/// status marker. The two are easy to conflate, so the spec states this
/// explicitly rather than leaving it implicit.
///
/// `radius.pill` — the same object-like exemption as Badge (§5.3); a tag
/// reads as a small physical token. Unselected: Level 1 hairline
/// `stone.30`/`outlineVariant` border, no fill. Selected/active (e.g. an
/// active filter): `moss.10`/`moss.90` wash fill (`primaryContainer`) +
/// `moss.60`/`primary` border — the exact `colorScheme.primaryContainer`/
/// `.primary` pairing [AppNavigationBar]'s selected-destination wash
/// already established, reused here for the identical "moss wash" role
/// rather than inventing a second expression of it.
class AppTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const AppTag({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final tone = selected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final radius = BorderRadius.circular(context.shape.radiusPill);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: motion.durationMicro,
          curve: motion.curveEnter,
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.sm,
            vertical: context.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primaryContainer : null,
            borderRadius: radius,
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: motion.durationMicro,
                curve: motion.curveEnter,
                style: TextStyle(
                  color: tone,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                child: Text(label),
              ),
              if (onRemove != null) ...[
                SizedBox(width: context.spacing.xs),
                _RemoveButton(color: tone, onTap: onRemove!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A small inline "×" — tapping it darkens via [InkWell]'s own splash,
/// the same press-feedback mechanism every other Tahap 2 interactive
/// component already uses (§10.15's "tapping it darkens on `motion.micro`"
/// is exactly what an ink splash *is*, not a separate bespoke animation).
/// No swipe-to-dismiss gesture by design — removal stays a deliberate tap.
class _RemoveButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _RemoveButton({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(Icons.close, size: 14, color: color),
        ),
      ),
    );
  }
}
