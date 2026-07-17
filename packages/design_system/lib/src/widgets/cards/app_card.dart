import 'package:flutter/material.dart';

import '../../theme/app_theme_context.dart';

/// Wraps [Card] with the design tokens applied and an optional tap target
/// (§16).
class AppCard extends StatelessWidget {
  final Widget child;

  /// Defaults to `EdgeInsets.all(context.spacing.md)` — `null` rather than
  /// a literal default because the spacing token now lives on
  /// `Theme.of(context)`, which isn't available at const-default-value
  /// evaluation time.
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: context.elevation.level1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.spacing.md),
          child: child,
        ),
      ),
    );
  }
}
