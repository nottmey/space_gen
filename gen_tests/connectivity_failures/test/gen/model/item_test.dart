// GENERATED — do not hand-edit.
import 'package:connectivity_failures/api.dart';
import 'package:test/test.dart';

void main() {
  group('Item', () {
    test('round-trips via maybeFromJson/toJson', () {
      final instance = Item(name: 'example');
      final parsed = Item.maybeFromJson(instance.toJson())!;
      expect(parsed, equals(instance));
      expect(parsed.hashCode, equals(instance.hashCode));
    });

    test('maybeFromJson returns null on null input', () {
      expect(Item.maybeFromJson(null), isNull);
    });

    test('maybeFromJson throws FormatException on invalid input', () {
      expect(
        () => Item.maybeFromJson(<String, dynamic>{}),
        throwsFormatException,
      );
    });
  });
}
