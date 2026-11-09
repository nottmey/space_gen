import 'package:connectivity_failures/model_helpers.dart';

class Problem {
  Problem({required this.reason});

  /// Converts a `Map<String, dynamic>` to a [Problem].
  factory Problem.fromJson(dynamic jsonArg) {
    final json = jsonArg as Map<String, dynamic>;
    return parseFromJson(
      'Problem',
      json,
      () => Problem(reason: json['reason'] as String),
    );
  }

  /// Convenience to create a nullable type from a nullable json object.
  /// Useful when parsing optional fields.
  static Problem? maybeFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Problem.fromJson(json);
  }

  String reason;

  /// Converts a [Problem] to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() {
    return {'reason': reason};
  }

  @override
  int get hashCode => reason.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Problem && reason == other.reason;
  }
}
