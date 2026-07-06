class TailorModel {
  final String id;
  final String shopName;
  final String ownerName;
  final String imagePath;
  final List<String> shopImages;
  final double rating;
  final String address;
  final String experience;
  final String workingHours;
  final String phone;
  final List<Map<String, dynamic>> reviews;

  const TailorModel({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.imagePath,
    required this.shopImages,
    required this.rating,
    required this.address,
    required this.experience,
    required this.workingHours,
    required this.phone,
    this.reviews = const [],
  });

  factory TailorModel.fromMap(String id, Map<String, dynamic> map) {
    return TailorModel(
      id: id,
      shopName: map['shopName'] as String? ?? '',
      ownerName: map['ownerName'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
      shopImages: List<String>.from(map['shopImages'] as List? ?? []),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] as String? ?? '',
      experience: map['experience'] as String? ?? '',
      workingHours: map['workingHours'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      reviews: List<Map<String, dynamic>>.from(map['reviews'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'ownerName': ownerName,
      'imagePath': imagePath,
      'shopImages': shopImages,
      'rating': rating,
      'address': address,
      'experience': experience,
      'workingHours': workingHours,
      'phone': phone,
      'reviews': reviews,
    };
  }
}
