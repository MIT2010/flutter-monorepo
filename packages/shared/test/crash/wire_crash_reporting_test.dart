import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

class _FakeCrashReporter implements CrashReporter {
  final List<(Object, StackTrace, bool)> recorded = [];

  @override
  Future<void> recordError(
    Object error,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    recorded.add((error, stack, fatal));
  }

  @override
  Future<void> setUserId(String? id) async {}
}

void main() {
  late FlutterExceptionHandler? originalFlutterOnError;
  late ErrorCallback? originalPlatformOnError;

  setUp(() {
    originalFlutterOnError = FlutterError.onError;
    originalPlatformOnError = PlatformDispatcher.instance.onError;
  });

  tearDown(() {
    FlutterError.onError = originalFlutterOnError;
    PlatformDispatcher.instance.onError = originalPlatformOnError;
  });

  group('wireCrashReporting', () {
    test(
      'FlutterError.onError forwards the exception to CrashReporter.recordError',
      () {
        final reporter = _FakeCrashReporter();
        wireCrashReporting(reporter);

        final exception = Exception('widget build blew up');
        final stack = StackTrace.current;
        FlutterError.onError!(
          FlutterErrorDetails(exception: exception, stack: stack),
        );

        expect(reporter.recorded, hasLength(1));
        expect(reporter.recorded.single.$1, exception);
        expect(reporter.recorded.single.$3, isTrue);
      },
    );

    test('PlatformDispatcher.instance.onError forwards errors that never '
        'go through the Flutter framework at all — the gap a Flutter-only '
        'wiring would miss', () {
      final reporter = _FakeCrashReporter();
      wireCrashReporting(reporter);

      final error = Exception('uncaught Future error');
      final stack = StackTrace.current;
      final handled = PlatformDispatcher.instance.onError!(error, stack);

      expect(handled, isTrue);
      expect(reporter.recorded, hasLength(1));
      expect(reporter.recorded.single.$1, error);
      expect(reporter.recorded.single.$3, isTrue);
    });
  });
}
