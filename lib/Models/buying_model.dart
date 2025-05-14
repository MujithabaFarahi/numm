import 'package:nummlk/Models/order_model.dart';

class Buying {
  final String id;
  final int? totalItems;
  final String? garment;
  final DateTime createdAt;
  final List<BagItem> bags;

  Buying({
    required this.id,
    this.totalItems,
    this.garment,
    required this.createdAt,
    required this.bags,
  });

  /// Factory constructor to create a Buying from Firestore data
  factory Buying.fromFirestore(Map<String, dynamic> data) {
    return Buying(
      id: data['id'] ?? '',
      totalItems: data['totalItems'] ?? 0,
      garment: data['garment'] ?? '',
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
      totalItems: map['totalItems'] ?? 0,
      garment: map['garment'] ?? '',
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
      'totalItems': totalItems,
      'garment': garment,
      'createdAt': createdAt.toIso8601String(),
      'bags': bags.map((bag) => bag.toMap()).toList(),
    };
  }

  /// Buyings a new Buying with updated fields
  Buying copyWith({
    String? id,
    int? totalItems,
    String? garment,
    DateTime? createdAt,
    List<BagItem>? bags,
  }) {
    return Buying(
      id: id ?? this.id,
      totalItems: totalItems ?? this.totalItems,
      garment: garment ?? this.garment,
      createdAt: createdAt ?? this.createdAt,
      bags: bags ?? this.bags,
    );
  }
}
