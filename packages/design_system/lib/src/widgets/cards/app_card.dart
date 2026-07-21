import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// A container for related content, not a design flourish (§10.2). Level 1
/// depth (hairline border, no shadow) at rest — even when [onTap] is set;
/// Level 2 (border + barely-visible shadow) appears only as *hover
/// feedback* on a tappable card, never as permanent decoration on a static
/// one, per §6's "depth as feedback, not decoration" rule for Level 2.
///
/// Builds its own [BoxDecoration] from [AppElevationExtension]'s named
/// depth levels rather than wrapping [Card] — [Card]'s `elevation` produces
/// Material's own drop-shadow curve, which can't express Verdant's literal
/// border/shadow-list spec (§6). [InkWell] still supplies real tap/hover
/// feedback and ripple.
@verdantStable
class AppCard extends StatefulWidget {
  final Widget child;

  /// Defaults to `EdgeInsets.all(context.spacing.md)` — `null` rather than
  /// a literal default because the spacing token now lives on
  /// `Theme.of(context)`, which isn't available at const-default-value
  /// evaluation time.
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.onTap});

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final depth = widget.onTap != null && _hovering
        ? context.elevation.lifted
        : context.elevation.resting;
    final radius = BorderRadius.circular(context.shape.radiusSm);

    return AnimatedContainer(
      duration: context.motion.durationMicro,
      curve: context.motion.curveEnter,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: depth.border,
        borderRadius: radius,
        boxShadow: depth.shadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onHover: widget.onTap == null
              ? null
              : (hovering) => setState(() => _hovering = hovering),
          borderRadius: radius,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(context.spacing.md),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
