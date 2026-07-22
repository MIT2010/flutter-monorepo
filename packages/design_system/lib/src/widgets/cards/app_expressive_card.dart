import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// A card that expresses confidence through color, not motion.
///
/// An earlier design morphed asymmetric corners and lifted elevation via
/// a spring physics simulation on tap — unmistakably a heavy, decorative
/// mechanic, retired entirely rather than retuned. The replacement is
/// deliberately quiet: the same fixed `radius.sm` geometry every card in
/// this system uses (no asymmetric/expressive variant survives as a
/// default), with only its hairline border shifting from
/// `colorScheme.outlineVariant` to `colorScheme.primary` on press. No
/// shape change, no elevation change, no spring — `motion.micro` with
/// Enter, the same restrained vocabulary every other interaction in this
/// system uses.
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
    final shape = context.shape;
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
        decoration: ShapeDecoration(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shape.radiusSm),
            side: BorderSide(color: borderColor),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.md),
          child: widget.child,
        ),
      ),
    );
  }
}
