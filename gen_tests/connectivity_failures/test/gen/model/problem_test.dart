// GENERATED — do not hand-edit.
import 'package:connectivity_failures/api.dart';
import 'package:test/test.dart';

void main() {
  group('Problem', () {
    test('round-trips via maybeFromJson/toJson', () {
      final instance = Problem(reason: 'example');
      final parsed = Problem.maybeFromJson(instance.toJson())!;
      expect(parsed, equals(instance));
      expect(parsed.hashCode, equals(instance.hashCode));
    });

    test('maybeFromJson returns null on null input', () {
      expect(Problem.maybeFromJson(null), isNull);
    });

    test('maybeFromJson throws FormatException on invalid input', () {
      expect(
        () => Problem.maybeFromJson(<String, dynamic>{}),
        throwsFormatException,
      );
    });
  });
}
