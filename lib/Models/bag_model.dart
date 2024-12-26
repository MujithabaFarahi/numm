class Bag {
  final String id;
  final String name;
  final String garment;
  final List<String> colors;
  final List<int> quantity;
  final int quantitySold;
  final DateTime createdAt;
  final DateTime lastUpdated;

  Bag({
    required this.id,
    required this.name,
    required this.garment,
    required this.colors,
    required this.quantity,
    required this.quantitySold,
    required this.createdAt,
    required this.lastUpdated,
  });

  /// Factory constructor to create a Bag from Firestore data
  factory Bag.fromFirestore(Map<String, dynamic> data) {
    return Bag(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      garment: data['garment'] ?? '',
      colors: List<String>.from(data['colors'] ?? []),
      quantity: List<int>.from(data['quantity'] ?? []),
      quantitySold: data['quantitySold'] ?? 0,
      createdAt:
          DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      lastUpdated: DateTime.parse(
          data['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Creates a Bag from a Map
  factory Bag.fromMap(Map<String, dynamic> map) {
    return Bag(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      garment: map['garment'] ?? '',
      colors: List<String>.from(map['colors'] ?? []),
      quantity: List<int>.from(map['quantity'] ?? []),
      quantitySold: map['quantitySold'] ?? 0,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastUpdated: DateTime.parse(
          map['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Converts a Bag object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'garment': garment,
      'colors': colors,
      'quantity': quantity,
      'quantitySold': quantitySold,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Returns a new Bag with updated fields
  Bag copyWith({
    String? id,
    String? name,
    String? garment,
    List<String>? colors,
    List<int>? quantity,
    int? quantitySold,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return Bag(
      id: id ?? this.id,
      name: name ?? this.name,
      garment: garment ?? this.garment,
      colors: colors ?? this.colors,
      quantity: quantity ?? this.quantity,
      quantitySold: quantitySold ?? this.quantitySold,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
