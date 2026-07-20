import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// A card that expresses confidence through color, not motion (§5.4).
///
/// The previous design morphed [AppShapeExtension.expressive]'s asymmetric
/// corners and lifted elevation via [AppMotionExtension.spring] on tap —
/// under Verdant's own anti-pattern critic pass, that mechanic is
/// unmistakably M3-Expressive-derived and was retired entirely, not
/// retuned. The replacement is deliberately quiet: the same fixed
/// `radius.sm` geometry every Verdant card uses (§10.2 — "no
/// asymmetric/expressive variant survives as a default"), with only its
/// hairline border shifting from `stone.20`/`outlineVariant` to
/// `moss.60`/`primary` on press. No shape change, no elevation change, no
/// spring — `motion.micro` with Verdant Enter, the same restrained
/// vocabulary every other Verdant interaction uses.
///
/// Respects the OS "reduce motion" accessibility setting
/// (`MediaQuery.disableAnimations`): the border color still changes on
/// press when set, just instantly rather than animated — the same
/// jump-not-animate precedent the original component established (§8.7),
/// carried forward here rather than dropped with the spring mechanic.
class AppExpressiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppExpressiveCard({super.key, required this.child, this.onTap});

  @override
  State<AppExpressiveCard> createState() => _AppExpressiveCardState();
}

class _AppExpressiveCardState extends State<AppExpressiveCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final radius = BorderRadius.circular(context.shape.radiusSm);
    final borderColor = _pressed
        ? colorScheme.primary
        : colorScheme.outlineVariant;

    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => _setPressed(true),
      onTapUp: widget.onTap == null ? null : (_) => _setPressed(false),
      onTapCancel: widget.onTap == null ? null : () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: reduceMotion ? Duration.zero : motion.durationMicro,
        curve: motion.curveEnter,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: borderColor),
          borderRadius: radius,
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.md),
          child: widget.child,
        ),
      ),
    );
  }
}
