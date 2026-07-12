import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Shared plumbing for every golden test in this folder (§28 — design_system
/// components only, ~10-widget-state target, not full pages).
///
/// A fixed surface size makes every capture deterministic regardless of the
/// test host's default window size — without this, the same widget can
/// legitimately render at a different pixel size machine to machine.
///
/// Golden files in this repo are only ever trustworthy when regenerated on
/// the same platform CI compares them against (Linux/`ubuntu-latest`) — see
/// CONTRIBUTING.md's "Regenerating golden files" section for why a local
/// `--update-goldens` run on Windows/macOS is a draft, not the real
/// baseline, and how to get the real one.
Future<void> pumpGolden(
  WidgetTester tester, {
  required Widget child,
  required ThemeData theme,
  Size surfaceSize = const Size(400, 200),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: child)),
    ),
  );
  // Bounded pumps, not `pumpAndSettle` — `AppButton(loading: true)` renders
  // an indeterminate `CircularProgressIndicator`, whose animation never
  // settles and would make `pumpAndSettle` hang until it times out (same
  // gotcha already documented in akujamin-v2's docs/qa/register.md).
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

final lightTheme = AppTheme.light();
final darkTheme = AppTheme.dark();
