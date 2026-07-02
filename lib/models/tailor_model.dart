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
}
