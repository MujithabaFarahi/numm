import 'package:nummlk/Models/order_model.dart';

class Return {
  final String returnId;
  final String? orderDealer;
  final int? totalItems;
  final bool? darazOrder;
  final DateTime createdAt;
  final List<BagItem> bags;

  Return({
    required this.returnId,
    this.orderDealer,
    this.totalItems,
    this.darazOrder,
    required this.createdAt,
    required this.bags,
  });

  /// Factory constructor to create a Return from Firestore data
  factory Return.fromFirestore(Map<String, dynamic> data) {
    return Return(
      returnId: data['returnId'] ?? '',
      orderDealer: data['orderDealer'],
      totalItems: data['totalItems'],
      darazOrder: data['darazOrder'],
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
      orderDealer: map['orderDealer'],
      totalItems: map['totalItems'],
      darazOrder: map['darazOrder'] ?? true,
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
      'orderDealer': orderDealer,
      'totalItems': totalItems,
      'darazOrder': darazOrder,
      'createdAt': createdAt.toIso8601String(),
      'bags': bags.map((bag) => bag.toMap()).toList(),
    };
  }

  /// Returns a new Return with updated fields
  Return copyWith({
    String? returnId,
    String? orderDealer,
    int? totalItems,
    bool? darazOrder,
    DateTime? createdAt,
    List<BagItem>? bags,
  }) {
    return Return(
      returnId: returnId ?? this.returnId,
      orderDealer: orderDealer ?? this.orderDealer,
      totalItems: totalItems ?? this.totalItems,
      darazOrder: darazOrder ?? this.darazOrder,
      createdAt: createdAt ?? this.createdAt,
      bags: bags ?? this.bags,
    );
  }
}
