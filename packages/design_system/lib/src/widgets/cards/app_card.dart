import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// A container for related content, not a design flourish (§10.2). Level 1
/// depth (hairline border, no shadow) at rest — even when [onTap] is set;
/// Level 2 (border + barely-visible shadow) appears only as *hover
/// feedback* on a tappable card, never as permanent decoration on a static
/// one, per §6's "depth as feedback, not decoration" rule for Level 2.
///
/// Builds its own [ShapeDecoration] from [AppElevationExtension]'s named
/// depth levels rather than wrapping [Card] — [Card]'s `elevation` produces
/// Material's own drop-shadow curve, which can't express Verdant's literal
/// border/shadow-list spec (§6). [InkWell] still supplies real tap/hover
/// feedback and ripple, via `customBorder` rather than `borderRadius` so
/// the ripple itself is clipped to the same rounded silhouette too.
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
    final shape = context.shape;
    final side = depth.border is Border
        ? (depth.border as Border).top
        : BorderSide.none;
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(shape.radiusSm),
      side: side,
    );

    return AnimatedContainer(
      duration: context.motion.durationMicro,
      curve: context.motion.curveEnter,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: border,
        shadows: depth.shadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onHover: widget.onTap == null
              ? null
              : (hovering) => setState(() => _hovering = hovering),
          customBorder: border,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(context.spacing.md),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
