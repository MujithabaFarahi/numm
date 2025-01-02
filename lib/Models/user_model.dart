class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final double itemsProcessed;
  final int orderDeals;
  final DateTime createdAt;
  final DateTime lastUpdated;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.itemsProcessed,
    required this.orderDeals,
    required this.createdAt,
    required this.lastUpdated,
  });

  /// Factory constructor to create a User from Firestore data
  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      itemsProcessed: (data['itemsProcessed'] ?? 0.0).toDouble(),
      orderDeals: data['orderDeals'] ?? 0,
      createdAt:
          DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      lastUpdated: DateTime.parse(
          data['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Creates a User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      itemsProcessed: (map['itemsProcessed'] ?? 0.0).toDouble(),
      orderDeals: map['orderDeals'] ?? 0,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastUpdated: DateTime.parse(
          map['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Converts a User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'itemsProcessed': itemsProcessed,
      'orderDeals': orderDeals,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Returns a new User with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    double? itemsProcessed,
    int? orderDeals,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      itemsProcessed: itemsProcessed ?? this.itemsProcessed,
      orderDeals: orderDeals ?? this.orderDeals,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
