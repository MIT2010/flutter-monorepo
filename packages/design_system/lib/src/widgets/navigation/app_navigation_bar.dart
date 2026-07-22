import 'package:flutter/material.dart';

import '../../maturity/verdant_maturity.dart';
import '../../theme/app_theme_context.dart';
import '../accents/verdant_edge_accent.dart';

/// One tab in an [AppNavigationBar] — icon + label only, no business logic
/// (design_system is a leaf package, §16). Consumers (e.g.
/// `packages/shared`'s `AppShell`) map their own richer destination model
/// onto this.
class AppNavigationDestination {
  final IconData icon;
  final String label;

  const AppNavigationDestination({required this.icon, required this.label});
}

/// Orientation, minimized — a navigation bar is signage, not a feature
/// (§10.4). A hand-built bottom bar rather than a wrapped [NavigationBar]:
/// Flutter's stock widget only supports a pill/chip indicator behind the
/// icon, which is exactly the Material navigation-bar "tell" §10.4 asks to
/// avoid — there's no public hook to turn that indicator into an edge bar.
///
/// - **Depth**: Level 1 — a single hairline top border, never a shadow
///   (navigation shouldn't look like it's floating above the content it
///   organizes).
/// - **Selected state**: §8.2's selection language, adapted for a
///   bottom-anchored bar — the spec's "left-edge bar" is written for
///   vertical lists/sidebars; for a horizontal bottom bar the analogous
///   edge (the one nearest the content it's indicating) is the *top* edge
///   of the selected cell. A 2px `moss.60` top bar plus a `moss.10`/
///   `moss.90` wash behind the icon+label, not a filled pill/chip.
/// - **Icons**: the same icon regardless of selection, only recolored —
///   never the filled-when-selected/outline-when-not toggle, one of
///   Material's most recognizable navigation-bar tells.
@verdantStable
class AppNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppNavigationDestination> destinations;

  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final motion = context.motion;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          // minHeight, not a fixed SizedBox -- a label that needs two
          // lines at a large MediaQuery.textScaler must be able to grow
          // the bar taller instead of clipping (VERDANT_DESIGN_SYSTEM.md
          // §14.3's own rule, caught failing this exact case in
          // test/accessibility/text_scaling_test.dart before this fix).
          constraints: const BoxConstraints(minHeight: 64),
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _Destination(
                    destination: destinations[i],
                    selected: i == selectedIndex,
                    duration: motion.durationMicro,
                    curve: motion.curveEnter,
                    onTap: () => onDestinationSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destination extends StatelessWidget {
  final AppNavigationDestination destination;
  final bool selected;
  final Duration duration;
  final Curve curve;
  final VoidCallback onTap;

  const _Destination({
    required this.destination,
    required this.selected,
    required this.duration,
    required this.curve,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tone = selected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: VerdantEdgeAccent(
          selected: selected,
          color: colorScheme.primary,
          fill: colorScheme.primaryContainer,
          side: VerdantEdgeSide.top,
          width: 2,
          duration: duration,
          curve: curve,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(destination.icon, color: tone, size: 24),
              SizedBox(height: context.spacing.xxxs),
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: curve,
                style:
                    (Theme.of(context).textTheme.labelSmall ??
                            const TextStyle())
                        .copyWith(color: tone),
                child: Text(destination.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
