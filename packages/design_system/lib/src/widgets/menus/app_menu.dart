import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';

/// One choice in an [AppMenu] — a value, a label, and an optional
/// leading icon (context menus commonly pair an action with a glyph;
/// [AppDropdown]'s own option rows don't need one, which is why
/// [AppDropdownItem] doesn't carry this field).
class AppMenuItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppMenuItem({required this.value, required this.label, this.icon});
}

/// A transient list of actions or choices, presented adjacent to
/// whatever triggered it (§10.23) — context menus, overflow menus,
/// dropdown option lists. `radius.md`, Level 3 depth (floating, full
/// shadow, the same `stone.10`/`stone.95` surface-tone shift as Dialog,
/// scaled down to menu size rather than a separate level).
///
/// **Item states — a named exception to §8.2, for the same reason as
/// Table (§10.13)**: hover/focus is a flat background tint, no edge bar
/// — a menu item is a one-shot action, not a persisted selection.
///
/// Built on [showGeneralDialog] rather than a raw [OverlayEntry] (the
/// approach [AppDropdown]'s own option list took in the prior batch) —
/// `showGeneralDialog`'s route machinery calls `transitionBuilder` for
/// *both* entrance and dismissal automatically, so the exit gets a real
/// animation for free, unlike [AppDropdown]'s disclosed instant-exit
/// gap. This is intentionally a standalone, general-purpose component
/// rather than a retrofit into [AppDropdown]'s existing, already-shipped
/// option list — merging them is a real future opportunity, not one
/// taken here, since it would mean modifying already-CI-green code from
/// a prior batch for a refactor nobody asked for.
///
/// **Disclosed gaps**, both deliberate:
/// - Anchored at a raw [Offset] with simple clamping to stay on-screen —
///   no smart flip-above-when-no-room-below logic, the same scope
///   boundary [AppDropdown]'s overlay already drew for the identical
///   reason (real screen-edge avoidance is a materially bigger, separate
///   problem).
/// - `showGeneralDialog` has no public parameter for an asymmetric
///   enter/exit duration — confirmed by reading the framework source,
///   not assumed. Both directions play over `motion.panel`, so the exit
///   is slightly slower than §10.23's literal `motion.standard`, a
///   disclosed timing gap in the same spirit as [AppDialog]'s own.
@verdantPreview
class AppMenu {
  const AppMenu._();

  static Future<T?> show<T>(
    BuildContext context, {
    required Offset position,
    required List<AppMenuItem<T>> items,
    double width = 240,
  }) {
    final motion = context.motion;

    return showGeneralDialog<T>(
      context: context,
      barrierLabel: 'Menu',
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      transitionDuration: motion.durationPanel,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final screenSize = MediaQuery.of(dialogContext).size;
        final left = position.dx.clamp(
          0.0,
          (screenSize.width - width).clamp(0.0, double.infinity),
        );
        final top = position.dy.clamp(0.0, screenSize.height - 48);

        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: width,
              child: _AppMenuContent<T>(items: items),
            ),
          ],
        );
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: motion.curveEnter,
          reverseCurve: motion.curveExit,
        );
        return FadeTransition(
          opacity: curved,
          child: Align(
            alignment: Alignment.topLeft,
            child: ScaleTransition(
              scale: curved,
              alignment: Alignment.topLeft,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _AppMenuContent<T> extends StatelessWidget {
  final List<AppMenuItem<T>> items;

  const _AppMenuContent({required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shape = context.shape;
    final depth = context.elevation.floating;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 320),
        decoration: BoxDecoration(
          color: depth.surfaceColor ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(shape.radiusMd),
          boxShadow: depth.shadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(shape.radiusMd),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: context.spacing.xxs),
            children: [
              for (final item in items)
                _AppMenuItemRow<T>(
                  item: item,
                  onTap: () => Navigator.of(context).pop(item.value),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppMenuItemRow<T> extends StatefulWidget {
  final AppMenuItem<T> item;
  final VoidCallback onTap;

  const _AppMenuItemRow({required this.item, required this.onTap});

  @override
  State<_AppMenuItemRow<T>> createState() => _AppMenuItemRowState<T>();
}

class _AppMenuItemRowState<T> extends State<_AppMenuItemRow<T>> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: _hovering
          ? colorScheme.surfaceContainerHighest
          : Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (hovering) => setState(() => _hovering = hovering),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.sm,
            vertical: context.spacing.xs,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: context.spacing.xs),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
