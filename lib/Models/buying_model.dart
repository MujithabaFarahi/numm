import 'package:nummlk/Models/order_model.dart';

class Buying {
  final String id;
  final DateTime createdAt;
  final List<BagItem> bags;

  Buying({
    required this.id,
    required this.createdAt,
    required this.bags,
  });

  /// Factory constructor to create a Buying from Firestore data
  factory Buying.fromFirestore(Map<String, dynamic> data) {
    return Buying(
      id: data['id'] ?? '',
      createdAt:
          DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      bags: List<BagItem>.from(
          (data['bags'] ?? []).map((item) => BagItem.fromFirestore(item))),
    );
  }

  /// Creates a Buying from a Map
  factory Buying.fromMap(Map<String, dynamic> map) {
    return Buying(
      id: map['id'] ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      bags: List<BagItem>.from(
          (map['bags'] ?? []).map((item) => BagItem.fromMap(item))),
    );
  }

  /// Converts a Buying object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'bags': bags.map((bag) => bag.toMap()).toList(),
    };
  }

  /// Buyings a new Buying with updated fields
  Buying copyWith({
    String? id,
    DateTime? createdAt,
    List<BagItem>? bags,
  }) {
    return Buying(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      bags: bags ?? this.bags,
    );
  }
}
