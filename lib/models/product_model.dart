class ProductModel {
  final String id;
  final String name;
  final String imagePath;
  final double price;
  final double rating;
  final int totalOrders;
  final String description;
  final String material;
  final String size;

  const ProductModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.totalOrders,
    required this.description,
    required this.material,
    required this.size,
  });
}
