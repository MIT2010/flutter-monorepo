import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';

/// "Verdant Bank" -- a UI template exercising every design_system
/// component in real, navigable screens. `theme`/`darkTheme` come
/// straight from design_system, exactly the way apps/mobile's own `App`
/// widget wires them -- no local theme overrides anywhere in this app.
class VerdantBankApp extends StatelessWidget {
  const VerdantBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Verdant Bank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
