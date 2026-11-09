// See gen_tests/optional_status_code.json, generated with
// --optional-status-code. A request that gets no HTTP response must not
// pass for a 400: it throws ApiException with a null code and the original
// error as innerException. Responses keep their real status code.
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:optional_status_code/api.dart';
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
    final failures = <String, Object>{
      'SocketException': const SocketException('connection refused'),
      'TlsException': const TlsException('bad certificate'),
      'other IOException': const FileSystemException('disk gone'),
      'ClientException': ClientException('Failed to fetch'),
      'any other Exception': TimeoutException('too slow'),
    };

    for (final MapEntry(key: name, value: error) in failures.entries) {
      test('$name has a null code and keeps the original error', () async {
        final exception = await thrownBy(apiFailingWith(error).getItem);
        expect(exception.code, isNull);
        expect(exception.innerException, same(error));
        expect(exception.body, isNull);
      });
    }

    test('the message names the method and path', () async {
      final exception = await thrownBy(
        apiFailingWith(ClientException('Failed to fetch')).getItem,
      );
      expect(exception.message, 'HTTP connection failed: Method.get /item');
      expect(exception.toString(), startsWith('ApiException null: '));
    });
  });

  group('responses keep their status code', () {
    test('an error response has its code', () async {
      final exception = await thrownBy(
        apiRespondingWith(503, '{"reason":"down"}').getItem,
      );
      expect(exception.code, 503);
    });

    test('a success response parses', () async {
      final item = await apiRespondingWith(200, '{"name":"a"}').getItem();
      expect(item.name, 'a');
    });
  });
}
