class TailorModel {
  final String id;
  final String name;
  final String imagePath;
  final double rating;
  final int totalOrders;
  final bool isVerified;
  final String location;
  final String description;

  const TailorModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.totalOrders,
    required this.isVerified,
    required this.location,
    required this.description,
  });

  /// Builds a TailorModel from a Firestore document snapshot's data.
  /// [id] is passed separately since Firestore keeps the doc ID out of
  /// the field map itself (it lives on the DocumentSnapshot, not in data()).
  factory TailorModel.fromMap(String id, Map<String, dynamic> map) {
    return TailorModel(
      id: id,
      name: map['name'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (map['totalOrders'] as num?)?.toInt() ?? 0,
      isVerified: map['isVerified'] as bool? ?? false,
      location: map['location'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  /// Converts to a map for writing to Firestore.
  /// `id` is deliberately excluded — it's the document ID, not a field.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'rating': rating,
      'totalOrders': totalOrders,
      'isVerified': isVerified,
      'location': location,
      'description': description,
    };
  }
}
