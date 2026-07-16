import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('Env', () {
    test('defaults to the dev flavor when no --dart-define is passed', () {
      expect(Env.current.flavor, Flavor.dev);
      expect(Env.current.isDev, isTrue);
      expect(Env.current.isStaging, isFalse);
      expect(Env.current.isProd, isFalse);
    });

    test('apiVersion defaults to blank, and apiUrl is just the base URL — a '
        'version segment is opt-in per backend, not assumed (see '
        'joinApiUrl, ADR-015)', () {
      expect(Env.current.apiVersion, isEmpty);
      expect(Env.current.apiUrl, Env.current.apiBaseUrl);
    });
  });

  group('joinApiUrl', () {
    test('returns the bare base URL when apiVersion is blank', () {
      expect(
        joinApiUrl('https://api.example.com', ''),
        'https://api.example.com',
      );
    });

    test('appends the version segment when apiVersion is set — a backend '
        'that adopts versioning later needs only a flavors/*.json edit, not '
        'a code change', () {
      expect(
        joinApiUrl('https://api.example.com', 'v2'),
        'https://api.example.com/v2',
      );
    });
  });
}
