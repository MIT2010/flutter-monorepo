import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../shape/verdant_notched_border.dart';
import '../../theme/app_theme_context.dart';

/// Supplementary, non-essential context on hover/long-press (§10.21) —
/// must never carry information required to complete a task. `radius.xs`,
/// Level 3 depth (the exact same shadow values §6 defines, not a
/// separately-scaled "smaller Level 3").
///
/// **The one deliberate color inversion in the system**: background/text
/// swap to `colorScheme.onSurface`/`colorScheme.surface` — literally the
/// normal surface/onSurface pairing reversed, which is precisely
/// `stone.90` background + `stone.0` text in light mode (both roles
/// already map to exactly those tiers) and mirrors correctly in dark
/// mode for free, with no new tokens needed.
///
/// Wraps stock [Tooltip] rather than hand-building — verified against
/// the framework source before committing to this, not assumed: its
/// entrance/exit animation is a plain [FadeTransition] with no scale or
/// slide component at all in this Flutter version, which is exactly
/// what §10.21 calls for ("opacity only, no slide or scale").
///
/// **Disclosed gap**: [Tooltip] exposes `exitDuration` (set here to
/// `motion.micro`) but has no public constructor parameter for the
/// entrance fade's own duration — confirmed by reading the framework
/// source rather than assumed, the same way [AppTabs]' curve gap was
/// confirmed. The entrance plays on Flutter's own internal default
/// rather than a literal `motion.micro` value.
@verdantPreview
class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const AppTooltip({super.key, required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final shape = context.shape;
    final depth = context.elevation.floating;

    return Tooltip(
      message: message,
      exitDuration: motion.durationMicro,
      decoration: ShapeDecoration(
        color: colorScheme.onSurface,
        shape: VerdantNotchedBorder(
          radiusTopLeft: shape.radiusXs,
          radiusBottomLeft: shape.radiusXs,
          radiusBottomRight: shape.radiusXs,
          notch: shape.notchXs,
        ),
        shadows: depth.shadow,
      ),
      // Derived from the theme's own text theme rather than a bare
      // TextStyle(color:, fontSize:) -- Tooltip's overlay doesn't merge
      // its `textStyle` against the ambient DefaultTextStyle the way a
      // plain Text widget would, so a bare TextStyle here silently lost
      // the app's Plus Jakarta Sans fontFamily and rendered as tofu
      // (empty glyph boxes) instead of legible text. Caught by actually
      // looking at the rendered PNG -- the golden test never asserted on
      // text content, only on decoration colors, so this would have
      // shipped unnoticed on a green suite otherwise.
      textStyle: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: colorScheme.surface),
      child: child,
    );
  }
}
