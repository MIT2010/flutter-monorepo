import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Generic fallback for [AppRouter]'s `errorBuilder` (§13). Kept here
/// rather than in a feature package — it's routing infrastructure, not a
/// product screen (§5: `shared` never contains feature-specific screens,
/// but it does own the router it renders errors for).
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Page not found'),
              SizedBox(height: context.spacing.md),
              AppButton(label: 'Go home', onPressed: () => context.go('/home')),
            ],
          ),
        ),
      ),
    );
  }
}
