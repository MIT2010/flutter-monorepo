import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Picked up automatically by `flutter test` for every file under this
/// directory. Without this, Flutter's test binding renders all text as
/// deterministic placeholder glyph blocks regardless of `fontFamily` --
/// real for CI determinism, but it also means a golden test can never
/// visually prove a typeface choice on its own (confirmed against
/// Flutter's own docs, see ARCHITECTURE.md ADR-017's follow-up).
/// Loading Plus Jakarta Sans's real bytes here (bundled locally under
/// `fonts/`, not fetched over the network -- same offline guarantee
/// `AppTheme` already relies on) makes golden tests render its actual
/// glyphs, so a baseline genuinely reflects the font instead of being
/// blind to it.
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
