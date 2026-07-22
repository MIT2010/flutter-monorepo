import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// One consistent "you are here / this is selected" language —
/// a persistent leading-edge accent bar, not a fill wash by itself.
///
/// Formalizes the treatment `AppSidebar`/`AppNavigationBar` already used
/// ad hoc (a left-edge `BorderSide` that recolors on selection) into a
/// single reusable widget, so every row/item-style selection surface
/// (sidebar destinations, nav bar destinations, table rows, dropdown/menu
/// items, list rows) reaches for the same signal instead of six
/// components independently reinventing "just fill it primary" — which
/// is also exactly the language Material's own selected-state components
/// already use.
///
/// [fill] is optional and deliberately subtle when supplied (a
/// `primaryContainer`-tier wash, not a saturated fill) — the edge bar is
/// the signal that has to carry the state on its own; the fill is a
/// secondary reinforcement, never the primary one.
class AppEdgeAccent extends StatelessWidget {
  const AppEdgeAccent({
    super.key,
    required this.selected,
    required this.color,
    required this.child,
    this.width = 3,
    this.fill,
    this.side = AppEdgeSide.left,
    this.shadow,
    this.duration,
    this.curve,
  });

  final bool selected;
  final Color color;
  final Widget child;
  final double width;
  final Color? fill;
  final AppEdgeSide side;

  /// Optional shadow (e.g. `AppElevationExtension.lifted.shadow` on
  /// hover) — a row that's edge-to-edge by design (the divider *is* the
  /// border language, so a boxed border on hover would read as a card,
  /// not a list row) still needs somewhere to hang hover-lift feedback.
  final List<BoxShadow>? shadow;
  final Duration? duration;
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final accentSide = BorderSide(
      color: selected ? color : Colors.transparent,
      width: width,
    );

    return AnimatedContainer(
      duration: duration ?? motion.durationMicro,
      curve: curve ?? motion.curveEnter,
      decoration: BoxDecoration(
        color: selected ? fill : null,
        border: switch (side) {
          AppEdgeSide.left => Border(left: accentSide),
          AppEdgeSide.top => Border(top: accentSide),
          AppEdgeSide.bottom => Border(bottom: accentSide),
        },
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}

/// [top] is the bottom-navigation-bar case — §8.2's edge language is
/// written for vertical lists where "leading edge" means left; for a
/// horizontal bottom bar the analogous edge (nearest the content it's
/// indicating) is the cell's top, not its left.
enum AppEdgeSide { left, top, bottom }
