// See gen_tests/connectivity_failures.json, generated with
// --connectivity-failures. A request that gets no HTTP response must not
// pass for a 400: it throws ApiException with a null code and a
// ConnectivityFailure naming why. Responses keep their real status code.
import 'dart:async';
import 'dart:io';

import 'package:connectivity_failures/api.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

DefaultApi apiFailingWith(Object error) => DefaultApi(
  ApiClient(
    client: MockClient((request) async {
      throw error;
    }),
  ),
);

DefaultApi apiRespondingWith(int statusCode, String body) => DefaultApi(
  ApiClient(
    client: MockClient((request) async {
      return Response(body, statusCode);
    }),
  ),
);

Future<ApiException<Object?>> thrownBy(Future<Object?> Function() call) async {
  try {
    await call();
  } on ApiException<Object?> catch (e) {
    return e;
  }
  throw StateError('expected an ApiException');
}

void main() {
  group('transport failures have no status code', () {
    final failures = <String, (Object, ConnectivityFailure)>{
      'SocketException': (
        const SocketException('connection refused'),
        ConnectivityFailure.socket,
      ),
      'TlsException': (
        const TlsException('bad certificate'),
        ConnectivityFailure.tls,
      ),
      'other IOException': (
        const FileSystemException('disk gone'),
        ConnectivityFailure.io,
      ),
      'ClientException': (
        ClientException('Failed to fetch'),
        ConnectivityFailure.client,
      ),
      'any other Exception': (
        TimeoutException('too slow'),
        ConnectivityFailure.unknown,
      ),
    };

    for (final MapEntry(key: name, value: (error, failure))
        in failures.entries) {
      test('$name is classified as ${failure.name}', () async {
        final exception = await thrownBy(apiFailingWith(error).getItem);
        expect(exception.code, isNull);
        expect(exception.connectivityFailure, failure);
        expect(exception.innerException, same(error));
        expect(exception.body, isNull);
      });
    }

    test('the message names the method and path', () async {
      final exception = await thrownBy(
        apiFailingWith(ClientException('Failed to fetch')).getItem,
      );
      expect(exception.message, 'HTTP connection failed: Method.get /item');
      expect(exception.toString(), contains('connectivity failure (client)'));
    });
  });

  group('responses keep their status code', () {
    test('an error response has a code and no connectivity failure', () async {
      final exception = await thrownBy(
        apiRespondingWith(503, '{"reason":"down"}').getItem,
      );
      expect(exception.code, 503);
      expect(exception.connectivityFailure, isNull);
    });

    test('a success response parses', () async {
      final item = await apiRespondingWith(200, '{"name":"a"}').getItem();
      expect(item.name, 'a');
    });
  });
}
