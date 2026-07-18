import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../../theme/app_theme_context.dart';

/// Flagship demo of the shape + motion tokens working together: on tap,
/// morphs from a plain rounded rectangle to [AppShapeExtension.expressive]'s
/// non-uniform corners while lifting elevation, driven by
/// [AppMotionExtension.spring] (native `SpringSimulation`, not the
/// m3e_design package — see the design_system token-upgrade proposal,
/// 2026-07-17).
///
/// Respects the OS "reduce motion" accessibility setting
/// (`MediaQuery.disableAnimations`): when set, the shape/elevation change
/// still happens on tap, but instantly rather than via spring physics —
/// this is not optional for a component other widgets are meant to copy.
class AppExpressiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppExpressiveCard({super.key, required this.child, this.onTap});

  @override
  State<AppExpressiveCard> createState() => _AppExpressiveCardState();
}

class _AppExpressiveCardState extends State<AppExpressiveCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration.zero);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = target;
      return;
    }
    final spring = context.motion.spring;
    _controller.animateWith(
      SpringSimulation(spring, _controller.value, target, 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shape = context.shape;
    final elevation = context.elevation;

    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => _animateTo(1.0),
      onTapUp: widget.onTap == null ? null : (_) => _animateTo(0.0),
      onTapCancel: widget.onTap == null ? null : () => _animateTo(0.0),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final radius = BorderRadius.lerp(
            BorderRadius.circular(shape.radiusMd),
            shape.expressive,
            t,
          )!;
          final currentElevation =
              elevation.level1 + (elevation.level3 - elevation.level1) * t;
          return Material(
            elevation: currentElevation,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: child,
          );
        },
        child: Padding(
          padding: EdgeInsets.all(context.spacing.md),
          child: widget.child,
        ),
      ),
    );
  }
}
