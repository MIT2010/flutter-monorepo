import 'package:dio/dio.dart';

/// On a 401, pauses concurrent failing requests behind a single in-flight
/// `/auth/refresh` call, replays each request once refreshed, and forces
/// logout if the refresh itself fails (§9, §10).
///
/// `core` doesn't know about `/auth/refresh` — that call is injected as
/// [onRefreshToken] by the `authentication` package.
///
/// If [onRefreshToken] makes its own request through the same [Dio]
/// instance this interceptor is attached to (the natural way to implement
/// it), and that request *also* 401s, [onError] re-enters while the
/// outer call is still awaiting [onRefreshToken] — the reentrant call
/// awaits the very `Future` it would need to complete first, and neither
/// ever resolves. [excludedPaths] breaks that cycle: any request path
/// listed there is passed straight through on a 401 instead of triggering
/// another refresh attempt, so callers should include whichever path(s)
/// [onRefreshToken] itself calls (e.g. `/auth/refresh`, and typically
/// `/auth/login` too, since a login's own 401 is a wrong-credentials
/// error, not an expired-session one).
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final Future<bool> Function() onRefreshToken;
  final void Function() onRefreshFailed;
  final Set<String> excludedPaths;

  RefreshTokenInterceptor(
    this._dio, {
    required this.onRefreshToken,
    required this.onRefreshFailed,
    this.excludedPaths = const {},
  });

  static const _refreshRetriedKey = 'refreshRetried';

  Future<bool>? _refreshing;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra[_refreshRetriedKey] == true;
    final isExcluded = excludedPaths.contains(err.requestOptions.path);

    if (!isUnauthorized || alreadyRetried || isExcluded) {
      return handler.next(err);
    }

    final refreshed = await (_refreshing ??= _refresh());

    if (!refreshed) {
      onRefreshFailed();
      return handler.next(err);
    }

    try {
      final options = err.requestOptions..extra[_refreshRetriedKey] = true;
      final response = await _dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _refresh() async {
    try {
      return await onRefreshToken();
    } finally {
      _refreshing = null;
    }
  }
}
