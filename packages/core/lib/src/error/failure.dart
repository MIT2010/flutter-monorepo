/// Base type for every error that can cross the data → domain boundary.
/// The repository implementation is the only place allowed to catch a raw
/// exception and convert it into one of these (§7 of ARCHITECTURE.md).
sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

final class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnauthorizedFailure extends Failure {
  /// Defaults to a generic message for a session that expired with no
  /// server explanation (e.g. a stale/absent token), but a 401 caused by
  /// real credential validation (wrong password, wrong OTP) should pass
  /// the server's own message through instead of masking it.
  const UnauthorizedFailure([super.message = 'Session expired']);
}

/// A response was received and matched no [DioExceptionType] failure —
/// the body just didn't parse the way [ApiClient]'s caller-supplied
/// `parser` expected (a [TypeError]/[FormatException] from malformed or
/// unexpectedly-shaped JSON). Without this, that exception would escape
/// `ApiClient` uncaught instead of surfacing as a typed [Failure].
final class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}
