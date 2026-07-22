import 'package:flutter/material.dart';

/// Centered, unlabelled loading spinner -- `Center(child:
/// CircularProgressIndicator())` was hand-rolled identically 17 times
/// across this kit's own Home/Profile pages and 8 screens in `akujamin-v2`
/// (component-gap audit, 2026-07-18, see ARCHITECTURE.md ADR-017). No
/// parameters: no observed occurrence varied size, color, or added a
/// label -- for a labelled loading state, see `AppStateView(loading:
/// true, message: ...)` instead (docs/COMPONENT_ANATOMY.md §2/§1).
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
