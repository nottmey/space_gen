import 'package:connectivity_failures/model_helpers.dart';

class Item {
  Item({required this.name});

  /// Converts a `Map<String, dynamic>` to an [Item].
  factory Item.fromJson(dynamic jsonArg) {
    final json = jsonArg as Map<String, dynamic>;
    return parseFromJson(
      'Item',
      json,
      () => Item(name: json['name'] as String),
    );
  }

  /// Convenience to create a nullable type from a nullable json object.
  /// Useful when parsing optional fields.
  static Item? maybeFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Item.fromJson(json);
  }

  String name;

  /// Converts an [Item] to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Item && name == other.name;
  }
}
