class BagOrder {
  final String orderId;
  final String status;
  final DateTime createdAt;
  final List<BagItem> bags;
  final int totalItems;
  final List<Packager> packagers;
  final String? orderDealer;
  final bool darazOrder;

  BagOrder({
    required this.orderId,
    required this.status,
    required this.createdAt,
    required this.bags,
    required this.totalItems,
    required this.packagers,
    this.orderDealer,
    required this.darazOrder,
  });

  /// Factory constructor to create a BagOrder from Firestore data
  factory BagOrder.fromFirestore(Map<String, dynamic> data) {
    return BagOrder(
      orderId: data['orderId'] ?? '',
      status: data['status'] ?? '',
      createdAt:
          DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      bags: List<BagItem>.from(
          (data['bags'] ?? []).map((item) => BagItem.fromFirestore(item))),
      totalItems: data['totalItems'] ?? 0,
      packagers: List<Packager>.from((data['packagers'] ?? [])
          .map((item) => Packager.fromFirestore(item))),
      orderDealer: data['orderDealer'],
      darazOrder: data['darazOrder'] ?? false,
    );
  }

  /// Creates a BagOrder from a Map
  factory BagOrder.fromMap(Map<String, dynamic> map) {
    return BagOrder(
      orderId: map['orderId'] ?? '',
      status: map['status'] ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      bags: List<BagItem>.from(
          (map['bags'] ?? []).map((item) => BagItem.fromMap(item))),
      totalItems: map['totalItems'] ?? 0,
      packagers: List<Packager>.from(
          (map['packagers'] ?? []).map((item) => Packager.fromMap(item))),
      orderDealer: map['orderDealer'],
      darazOrder: map['darazOrder'] ?? false,
    );
  }

  /// Converts a BagOrder object to a Map
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'bags': bags.map((bag) => bag.toMap()).toList(),
      'totalItems': totalItems,
      'packagers': packagers.map((packager) => packager.toMap()).toList(),
      'orderDealer': orderDealer,
      'darazOrder': darazOrder,
    };
  }

  /// Returns a new BagOrder with updated fields
  BagOrder copyWith({
    String? orderId,
    String? status,
    DateTime? createdAt,
    List<BagItem>? bags,
    int? totalItems,
    List<Packager>? packagers,
    String? orderDealer,
    bool? darazOrder,
  }) {
    return BagOrder(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      bags: bags ?? this.bags,
      totalItems: totalItems ?? this.totalItems,
      packagers: packagers ?? this.packagers,
      orderDealer: orderDealer ?? this.orderDealer,
      darazOrder: darazOrder ?? this.darazOrder,
    );
  }
}

class Packager {
  final String name;
  final double itemsProcessed;

  Packager({
    required this.name,
    required this.itemsProcessed,
  });

  /// Factory constructor to create a Packager from Firestore data
  factory Packager.fromFirestore(Map<String, dynamic> data) {
    return Packager(
      name: data['name'] ?? '',
      itemsProcessed: (data['itemsProcessed'] ?? 0).toDouble(),
    );
  }

  /// Creates a Packager from a Map
  factory Packager.fromMap(Map<String, dynamic> map) {
    return Packager(
      name: map['name'] ?? '',
      itemsProcessed: (map['itemsProcessed'] ?? 0).toDouble(),
    );
  }

  /// Converts a Packager object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'itemsProcessed': itemsProcessed,
    };
  }
}

class BagItem {
  final String bagId;
  final int quantity;
  final String color;

  BagItem({
    required this.bagId,
    required this.quantity,
    required this.color,
  });

  /// Factory constructor to create a BagItem from Firestore data
  factory BagItem.fromFirestore(Map<String, dynamic> data) {
    return BagItem(
      bagId: data['bagId'] ?? '',
      quantity: data['quantity'] ?? 0,
      color: data['color'] ?? '',
    );
  }

  /// Creates a BagItem from a Map
  factory BagItem.fromMap(Map<String, dynamic> map) {
    return BagItem(
      bagId: map['bagId'] ?? '',
      quantity: map['quantity'] ?? 0,
      color: map['color'] ?? '',
    );
  }

  /// Converts a BagItem object to a Map
  Map<String, dynamic> toMap() {
    return {
      'bagId': bagId,
      'quantity': quantity,
      'color': color,
    };
  }

  /// Returns a new BagItem with updated fields
  BagItem copyWith({
    String? bagId,
    int? quantity,
    String? color,
  }) {
    return BagItem(
      bagId: bagId ?? this.bagId,
      quantity: quantity ?? this.quantity,
      color: color ?? this.color,
    );
  }
}
