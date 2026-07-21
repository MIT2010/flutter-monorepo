import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../addons/theme_studio_addon.dart';

const _destinations = [
  AppSidebarDestination(icon: Icons.home_outlined, label: 'Home'),
  AppSidebarDestination(icon: Icons.inbox_outlined, label: 'Inbox'),
  AppSidebarDestination(icon: Icons.settings_outlined, label: 'Settings'),
];

@widgetbook.UseCase(name: 'Extended', type: AppSidebar)
Widget appSidebarExtendedUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      height: 300,
      child: AppSidebar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: _destinations,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Collapsed', type: AppSidebar)
Widget appSidebarCollapsedUseCase(BuildContext context) {
  return Center(
    child: SizedBox(
      height: 300,
      child: AppSidebar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: _destinations,
        extended: false,
      ),
    ),
  );
}

/// **Per-instance knobs — deliberately separate from Theme Studio**, same
/// pattern as the rest of this catalog. [extended] as a knob is the point
/// of this use-case: it's the one property that's genuinely worth
/// toggling live to see the label fade-in/out §10.11 specifies.
@widgetbook.UseCase(name: 'Interactive', type: AppSidebar)
Widget appSidebarInteractiveUseCase(BuildContext context) {
  final extended = context.knobs.boolean(
    label: 'Extended (icon+label vs. icon-only)',
    initialValue: true,
  );

  final primaryColor = context.knobs.color(
    label: 'Primary color (moss — edge bar/wash)',
    initialValue: ThemeStudioSettings.defaultPrimaryLight,
  );
  final motionSpeedMultiplier = context.knobs.double.slider(
    label: 'Motion speed multiplier (width/label fade)',
    initialValue: 1,
    min: 0.5,
    max: 2,
    divisions: 30,
    precision: 2,
  );

  return _InteractiveSidebar(
    extended: extended,
    primaryColor: primaryColor,
    motionSpeedMultiplier: motionSpeedMultiplier,
  );
}

class _InteractiveSidebar extends StatefulWidget {
  final bool extended;
  final Color primaryColor;
  final double motionSpeedMultiplier;

  const _InteractiveSidebar({
    required this.extended,
    required this.primaryColor,
    required this.motionSpeedMultiplier,
  });

  @override
  State<_InteractiveSidebar> createState() => _InteractiveSidebarState();
}

class _InteractiveSidebarState extends State<_InteractiveSidebar> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(
        primaryColor: widget.primaryColor,
        motionSpeedMultiplier: widget.motionSpeedMultiplier,
      ),
      child: Center(
        child: SizedBox(
          height: 300,
          child: AppSidebar(
            selectedIndex: _selected,
            onDestinationSelected: (i) => setState(() => _selected = i),
            destinations: _destinations,
            extended: widget.extended,
          ),
        ),
      ),
    );
  }
}
