import 'package:meta/meta.dart';

/// Why a request failed before an HTTP response was received.
enum ConnectivityFailure {
  /// A socket operation failed: no route, connection refused or reset, DNS
  /// lookup failure.
  socket,

  /// The TLS handshake or certificate validation failed.
  tls,

  /// Another I/O error occurred while sending the request or reading the
  /// response.
  io,

  /// The HTTP client reported a failed connection. On web, `fetch` raises
  /// this for every request that got no response (offline, DNS, blocked by
  /// CORS) without saying which.
  client,

  /// Any other exception thrown while sending the request.
  unknown,
}

/// An exception thrown by the API client.
///
/// This is a wrapper around the underlying network exceptions.
/// This is used to provide a standard exception type for clients to handle.
///
/// A request that received an HTTP response has a [code] and no
/// [connectivityFailure]. A request that never received one has a `null`
/// [code] and a [connectivityFailure] classifying why.
///
/// The generic `T` is the parsed body of the error response, as declared by
/// the operation's `default:` (or error) response in the OpenAPI spec. For
/// operations that do not declare a typed error body, `T` is `dynamic` and
/// [body] is always null.
@immutable
class ApiException<T> implements Exception {
  const ApiException(this.code, this.message, {this.body})
    : connectivityFailure = null,
      innerException = null,
      stackTrace = null;

  const ApiException.unhandled(this.code)
    : message = 'Unhandled response',
      body = null,
      connectivityFailure = null,
      innerException = null,
      stackTrace = null;

  const ApiException.withInner(
    this.code,
    this.message,
    this.innerException,
    this.stackTrace,
  ) : body = null,
      connectivityFailure = null;

  const ApiException.connectivity(
    ConnectivityFailure this.connectivityFailure,
    this.message,
    this.innerException,
    this.stackTrace,
  ) : code = null,
      body = null;

  /// The HTTP status code, or `null` if no response was received.
  final int? code;
  final String? message;

  /// The parsed error body, if the operation's `default:` response declared
  /// a schema. Null otherwise.
  final T? body;

  /// Why no response was received, or `null` if there was one.
  final ConnectivityFailure? connectivityFailure;
  final Exception? innerException;
  final StackTrace? stackTrace;

  @override
  String toString() {
    if (message == null) {
      return 'ApiException';
    }
    final failure = connectivityFailure;
    final prefix = failure == null
        ? 'ApiException $code'
        : 'ApiException connectivity failure (${failure.name})';
    if (innerException == null) {
      return '$prefix: $message';
    }
    return '$prefix: $message '
        '(Inner exception: $innerException)\n\n$stackTrace';
  }
}
