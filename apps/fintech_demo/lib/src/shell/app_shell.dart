import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';

const _tabs = [Routes.home, Routes.cards, Routes.invest, Routes.profile];

const _navDestinations = [
  AppNavigationDestination(icon: Icons.home_outlined, label: 'Home'),
  AppNavigationDestination(icon: Icons.credit_card_outlined, label: 'Cards'),
  AppNavigationDestination(icon: Icons.trending_up_outlined, label: 'Invest'),
  AppNavigationDestination(icon: Icons.person_outline, label: 'Profile'),
];

const _sidebarDestinations = [
  AppSidebarDestination(icon: Icons.home_outlined, label: 'Home'),
  AppSidebarDestination(icon: Icons.credit_card_outlined, label: 'Cards'),
  AppSidebarDestination(icon: Icons.trending_up_outlined, label: 'Invest'),
  AppSidebarDestination(icon: Icons.person_outline, label: 'Profile'),
];

/// Wraps every top-level tab page (`/home`, `/cards`, `/invest`,
/// `/profile`) with a shared `AppNavigationBar` (mobile/tablet) or
/// `AppSidebar` (desktop, `AdaptiveLayout`/`Breakpoints`, §16) -- the
/// current tab is derived from the route itself (`GoRouterState`) rather
/// than kept as separate local state, so a direct link to e.g. `/cards`
/// still highlights the right destination.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _indexForLocation(String location) {
    final index = _tabs.indexWhere((tab) => location.startsWith(tab));
    return index == -1 ? 0 : index;
  }

  void _onSelect(BuildContext context, int index) {
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexForLocation(location);

    return AdaptiveLayout(
      mobile: (context) => Scaffold(
        body: child,
        bottomNavigationBar: AppNavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => _onSelect(context, i),
          destinations: _navDestinations,
        ),
      ),
      desktop: (context) => Scaffold(
        body: Row(
          children: [
            AppSidebar(
              selectedIndex: index,
              onDestinationSelected: (i) => _onSelect(context, i),
              destinations: _sidebarDestinations,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
