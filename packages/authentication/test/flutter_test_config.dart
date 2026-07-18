import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Picked up automatically by `flutter test` for every file under this
/// directory. Without this, Flutter's test binding renders all text as
/// deterministic placeholder glyph blocks regardless of `fontFamily` --
/// real for CI determinism, but it also means a golden test can never
/// visually prove a typeface choice on its own (see
/// packages/design_system/test/flutter_test_config.dart, the original of
/// this file, and ARCHITECTURE.md ADR-017's follow-up). Loading Plus
/// Jakarta Sans's real bytes here (owned by `design_system`, bundled
/// locally under its `fonts/` -- not fetched over the network) makes
/// this package's own page-level golden tests render its actual glyphs
/// too, since LoginPage renders through the same `AppTheme`.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadAppFonts();
  await testMain();
}

Future<void> _loadAppFonts() async {
  final loader = FontLoader('Plus Jakarta Sans')
    ..addFont(
      rootBundle.load(
        'packages/design_system/fonts/PlusJakartaSans-VariableFont_wght.ttf',
      ),
    );
  await loader.load();
}
