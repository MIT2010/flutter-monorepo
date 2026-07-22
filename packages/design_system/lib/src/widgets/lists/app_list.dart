import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';
import '../cards/app_card.dart';

/// The base scrollable unit almost every content screen is built from
/// (§10.12) — a row representing one item in a collection.
///
/// **Performance is part of this spec, not an afterthought**: the only
/// constructor takes `itemCount`/`itemBuilder`, the same lazy-building
/// contract as stock [ListView.builder] — there is no `children:` shortcut
/// that would force materializing every row up front. A settings screen
/// with 8 rows and a transaction history with 8,000 both go through the
/// identical code path; only the ones actually scrolled into view ever
/// get built. Internally backed by [ListView.separated] so the divider
/// is free virtualization-wise, not a second pass over the data.
///
/// `radius.none`, rows edge-to-edge separated by a `stone.20`/
/// `outlineVariant` hairline divider — the quiet, continuous-list
/// posture. [cardStyle] switches to the alternate "each row is its own
/// Level 1 [AppCard]" presentation named in §10.12: a `spacing.xs` gap
/// between cards replaces the divider (a divider line butted against a
/// card's own four-sided border would double up), and each item gets
/// wrapped in [AppCard] automatically rather than leaving that to every
/// call site.
///
/// Per-row selection/tap chrome (the edge-bar language, Level 2 hover)
/// lives in the companion [AppListRow] widget, not here — arbitrary row
/// content can't be wrapped generically the way a fixed icon+label
/// destination can (compare [AppNavigationBar]/[AppSidebar]), so
/// `itemBuilder` composes [AppListRow] itself when that chrome is wanted.
///
/// **Disclosed scope gap**: swipe-to-reveal-actions (§10.12's motion
/// line) isn't implemented. It's a materially separate gesture system
/// (closer to a purpose-built package than a `Dismissible` variant), and
/// the spec's own "where used" phrasing already treats it as optional,
/// not a baseline requirement every list needs.
@verdantPreview
class AppList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool cardStyle;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const AppList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.cardStyle = false,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (cardStyle) {
      return ListView.separated(
        itemCount: itemCount,
        shrinkWrap: shrinkWrap,
        physics: physics,
        separatorBuilder: (context, index) =>
            SizedBox(height: context.spacing.xs),
        itemBuilder: (context, index) =>
            AppCard(child: itemBuilder(context, index)),
      );
    }

    return ListView.separated(
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
      physics: physics,
      separatorBuilder: (context, index) =>
          Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
      itemBuilder: itemBuilder,
    );
  }
}

/// Standard row chrome for [AppList] items that are selectable and/or
/// tappable — the §8.2 edge-bar language plus Card's identical
/// hover-only-Level-2 rule (§10.2), applied to a flush list row instead
/// of a bordered card. Only [AppDepthLevel.shadow] is taken from
/// [AppElevationExtension.lifted] on hover, never its border — a list
/// row is edge-to-edge by design (the divider *is* the border language
/// here), so adding a boxed border on hover would read as a card, not a
/// list row.
@verdantPreview
class AppListRow extends StatefulWidget {
  final Widget child;
  final bool selected;
  final VoidCallback? onTap;

  const AppListRow({
    super.key,
    required this.child,
    this.selected = false,
    this.onTap,
  });

  @override
  State<AppListRow> createState() => _AppListRowState();
}

class _AppListRowState extends State<AppListRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final depth = widget.onTap != null && _hovering
        ? context.elevation.lifted
        : context.elevation.flush;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: widget.onTap,
        onHover: widget.onTap == null
            ? null
            : (hovering) => setState(() => _hovering = hovering),
        child: AnimatedContainer(
          duration: motion.durationMicro,
          curve: motion.curveEnter,
          decoration: BoxDecoration(
            color: widget.selected ? colorScheme.primaryContainer : null,
            border: Border(
              left: BorderSide(
                color: widget.selected
                    ? colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            boxShadow: depth.shadow,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.md,
            vertical: context.spacing.sm,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
