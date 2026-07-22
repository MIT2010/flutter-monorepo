import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';
import '../accents/app_edge_accent.dart';

/// One destination in an [AppSidebar] — icon + label only, no business
/// logic (design_system is a leaf package, §16), the same shape as
/// [AppNavigationDestination].
class AppSidebarDestination {
  final IconData icon;
  final String label;

  const AppSidebarDestination({required this.icon, required this.label});
}

/// Persistent navigation for wider viewports (§10.11) — the vertical
/// counterpart to [AppNavigationBar], sharing its exact selection
/// language (§8.2) rather than the bottom bar's top-edge adaptation:
/// this is the literal case that language was written for, so the
/// selected row gets a true *left*-edge `moss.60` bar plus the same
/// `moss.10`/`moss.90` wash.
///
/// `radius.none`, full-height flush panel, Level 1 hairline border along
/// the panel's *right* edge (mirrors nav bar's top-edge border for the
/// same reason — separate from content without implying the panel
/// floats above it). Hand-built rather than wrapping stock
/// [NavigationRail] for the identical reason [AppNavigationBar] already
/// rejected stock [NavigationBar]: no public hook to turn its default
/// pill/chip selection indicator into an edge bar.
///
/// [extended] toggles between the icon-only (collapsed) and icon+label
/// (expanded) width, animating via `motion.standard` + Enter/
/// Exit. The label stays in the tree at all times and fades via
/// [AnimatedOpacity] rather than being conditionally removed — a hard
/// swap would either truncate mid-animation with an ellipsis or pop in/
/// out abruptly, both of which §10.11 explicitly calls out as wrong.
class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppSidebarDestination> destinations;
  final bool extended;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.extended = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;

    return AnimatedContainer(
      duration: motion.durationStandard,
      curve: extended ? motion.curveEnter : motion.curveExit,
      width: extended ? 240 : 72,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(right: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: SafeArea(
        left: false,
        child: Column(
          children: [
            for (var i = 0; i < destinations.length; i++)
              _SidebarRow(
                destination: destinations[i],
                selected: i == selectedIndex,
                extended: extended,
                duration: motion.durationStandard,
                onTap: () => onDestinationSelected(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _SidebarRow extends StatelessWidget {
  final AppSidebarDestination destination;
  final bool selected;
  final bool extended;
  final Duration duration;
  final VoidCallback onTap;

  const _SidebarRow({
    required this.destination,
    required this.selected,
    required this.extended,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;
    final tone = selected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: AppEdgeAccent(
          selected: selected,
          color: colorScheme.primary,
          fill: colorScheme.primaryContainer,
          width: 2,
          duration: duration,
          curve: motion.curveEnter,
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                SizedBox(width: context.spacing.md),
                Icon(destination.icon, color: tone, size: 24),
                SizedBox(width: context.spacing.sm),
                Expanded(
                  child: ClipRect(
                    child: AnimatedOpacity(
                      opacity: extended ? 1 : 0,
                      duration: duration,
                      curve: extended ? motion.curveEnter : motion.curveExit,
                      child: Text(
                        destination.label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: tone),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
