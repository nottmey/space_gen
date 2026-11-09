import 'package:space_gen/templates/api_exception_connectivity.dart';
import 'package:test/test.dart';

void main() {
  group('ApiException with connectivity failures', () {
    test('a response has a code and no connectivity failure', () {
      const exception = ApiException<Object?>(404, 'not found');
      expect(exception.code, 404);
      expect(exception.connectivityFailure, isNull);
      expect(exception.toString(), 'ApiException 404: not found');
    });

    test('unhandled keeps the response code', () {
      const exception = ApiException<Object?>.unhandled(204);
      expect(exception.code, 204);
      expect(exception.connectivityFailure, isNull);
    });

    test('withInner keeps the response code', () {
      final inner = Exception('boom');
      final exception = ApiException<Object?>.withInner(
        500,
        'failed',
        inner,
        StackTrace.empty,
      );
      expect(exception.code, 500);
      expect(exception.connectivityFailure, isNull);
      expect(exception.innerException, inner);
    });

    test('connectivity has no code and names the failure', () {
      final inner = Exception('Failed to fetch');
      final exception = ApiException<Object?>.connectivity(
        ConnectivityFailure.client,
        'HTTP connection failed: Method.get /things',
        inner,
        StackTrace.empty,
      );
      expect(exception.code, isNull);
      expect(exception.connectivityFailure, ConnectivityFailure.client);
      expect(exception.body, isNull);
      expect(exception.innerException, inner);
      expect(
        exception.toString(),
        startsWith(
          'ApiException connectivity failure (client): '
          'HTTP connection failed: Method.get /things '
          '(Inner exception: Exception: Failed to fetch)',
        ),
      );
    });

    test('toString without a message is just the type name', () {
      const exception = ApiException<Object?>(500, null);
      expect(exception.toString(), 'ApiException');
    });
  });
}
