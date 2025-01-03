import 'package:nummlk/Models/order_model.dart';

class Return {
  final String returnId;
  final DateTime createdAt;
  final List<BagItem> bags;

  Return({
    required this.returnId,
    required this.createdAt,
    required this.bags,
  });

  /// Factory constructor to create a Return from Firestore data
  factory Return.fromFirestore(Map<String, dynamic> data) {
    return Return(
      returnId: data['returnId'] ?? '',
      createdAt:
          DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      bags: List<BagItem>.from(
          (data['bags'] ?? []).map((item) => BagItem.fromFirestore(item))),
    );
  }

  /// Creates a Return from a Map
  factory Return.fromMap(Map<String, dynamic> map) {
    return Return(
      returnId: map['returnId'] ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      bags: List<BagItem>.from(
          (map['bags'] ?? []).map((item) => BagItem.fromMap(item))),
    );
  }

  /// Converts a Return object to a Map
  Map<String, dynamic> toMap() {
    return {
      'returnId': returnId,
      'createdAt': createdAt.toIso8601String(),
      'bags': bags.map((bag) => bag.toMap()).toList(),
    };
  }

  /// Returns a new Return with updated fields
  Return copyWith({
    String? returnId,
    DateTime? createdAt,
    List<BagItem>? bags,
  }) {
    return Return(
      returnId: returnId ?? this.returnId,
      createdAt: createdAt ?? this.createdAt,
      bags: bags ?? this.bags,
    );
  }
}
