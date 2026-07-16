/// Compile-time `--dart-define` reader (§15, §31). Never hardcode a base
/// URL in feature code — always read `Env.current`.
enum Flavor { dev, staging, prod }

/// Pure, unit-testable on its own — see [Env.apiUrl]. `apiVersion` is
/// appended as an *extra* segment only when non-empty, so the same code
/// works unchanged for a backend with no versioning concept (leave
/// `API_VERSION` blank in `flavors/<flavor>.json`) and one that has it
/// (set `API_VERSION` to whatever segment it expects, e.g. `v1`) — a
/// `flavors/*.json` edit, not a code change, is what switches between the
/// two. **Confirmed against a real downstream project's backend,
/// 2026-07-15** (`akujamin-v2`, the same project ADR-011/012/013/014 came
/// from, see ADR-015): this kit previously assumed every backend is
/// versioned (`API_VERSION` defaulted to `'v1'`, unconditionally appended)
/// — a convention invented for this template, never derived from a real
/// backend, and the first real backend it was checked against turned out
/// to have no versioning concept at all, 404ing on every `/v1/...` call.
String joinApiUrl(String baseUrl, String apiVersion) =>
    apiVersion.isEmpty ? baseUrl : '$baseUrl/$apiVersion';

class Env {
  final Flavor flavor;
  final String apiBaseUrl;
  final String apiVersion;

  const Env._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.apiVersion,
  });

  static const _flavorName = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );
  static const _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.dev.example.com',
  );
  // Blank by default, not 'v1' — a version segment is opt-in per backend,
  // not assumed. See joinApiUrl's doc comment.
  static const _apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: '',
  );

  static final Env current = Env._(
    flavor: Flavor.values.firstWhere(
      (f) => f.name == _flavorName,
      orElse: () => Flavor.dev,
    ),
    apiBaseUrl: _apiBaseUrl,
    apiVersion: _apiVersion,
  );

  /// Base URL every API call is made against, e.g.
  /// `https://api.dev.example.com` (no `API_VERSION` set) or
  /// `https://api.dev.example.com/v1` (`API_VERSION=v1`).
  String get apiUrl => joinApiUrl(apiBaseUrl, apiVersion);

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}
