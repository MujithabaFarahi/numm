class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final double itemsProcessed;
  final int orderCount;
  // final DateTime createdAt;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.itemsProcessed,
    required this.orderCount,
    // required this.createdAt,
    required this.lastLogin,
  });

  /// Factory constructor to create a User from Firestore data
  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      itemsProcessed: (data['itemsProcessed'] ?? 0.0).toDouble(),
      orderCount: data['orderCount'] ?? 0,
      // createdAt:
      // DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin:
          DateTime.parse(data['lastLogin'] ?? DateTime.now().toIso8601String()),
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
      orderCount: map['orderCount'] ?? 0,
      // createdAt:
      // DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin:
          DateTime.parse(map['lastLogin'] ?? DateTime.now().toIso8601String()),
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
      'orderCount': orderCount,
      // 'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  /// Returns a new User with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    double? itemsProcessed,
    int? orderCount,
    // DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      itemsProcessed: itemsProcessed ?? this.itemsProcessed,
      orderCount: orderCount ?? this.orderCount,
      // createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
