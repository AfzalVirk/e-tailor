import '../models/tailor_model.dart';
import '../models/product_model.dart';

class MockDataService {
  MockDataService._();

  static List<TailorModel> getTailors() => const [
    TailorModel(
      id: 't1',
      name: 'Stitch & Style',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976163/tailor_1_bllexs.jpg',
      rating: 5.0,
      totalOrders: 153,
      isVerified: true,
      location: 'Lahore, Punjab',
      description:
          'Expert in formal wear, bridal suits, and alterations. '
          'Over 10 years of experience delivering boutique-quality stitching.',
    ),
    TailorModel(
      id: 't2',
      name: 'The Fitted Look',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_2_clc9iw.jpg',
      rating: 4.8,
      totalOrders: 145,
      isVerified: true,
      location: 'Karachi, Sindh',
      description:
          'Specialising in casual and semi-formal outfits. '
          'Fast turnaround, home pickup and drop-off available.',
    ),
    TailorModel(
      id: 't3',
      name: 'Prestige Tailors',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_3_od7lzp.jpg',
      rating: 4.9,
      totalOrders: 210,
      isVerified: true,
      location: 'Islamabad, ICT',
      description:
          'Premium bespoke tailoring for men and women. '
          'Specialising in shalwar kameez, suits, and wedding attire.',
    ),
    TailorModel(
      id: 't4',
      name: 'Thread & Needle Co.',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_4_nlnvmj.jpg',
      rating: 4.7,
      totalOrders: 98,
      isVerified: false,
      location: 'Faisalabad, Punjab',
      description:
          'Affordable quality stitching for everyday wear. '
          'Accepts bulk orders and urgent alterations.',
    ),
  ];

  static List<ProductModel> getProducts() => const [
    ProductModel(
      id: 'p1',
      name: 'Embroidered Lawn Suit',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976163/product_1_xytj3w.jpg',
      price: 3500,
      rating: 4.6,
      totalOrders: 54,
      description:
          'Premium lawn fabric with intricate hand embroidery. '
          'Perfect for summer occasions and casual gatherings.',
      material: 'Lawn Cotton',
      size: '2.5m x 1.2m',
    ),
    ProductModel(
      id: 'p2',
      name: 'Formal Silk Kurta',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/product_2_ylx1kr.jpg',
      price: 5200,
      rating: 4.8,
      totalOrders: 38,
      description:
          'Elegant silk kurta ideal for formal events and weddings. '
          'Available for custom sizing.',
      material: 'Pure Silk',
      size: '2.0m x 1.1m',
    ),
    ProductModel(
      id: 'p3',
      name: 'Casual Linen Outfit',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976162/product_3_eacftc.jpg',
      price: 2800,
      rating: 4.5,
      totalOrders: 72,
      description:
          'Breathable linen fabric for everyday comfort. '
          'Simple, clean design suitable for all occasions.',
      material: 'Linen',
      size: '2.2m x 1.0m',
    ),
    ProductModel(
      id: 'p4',
      name: 'Bridal Chiffon Dress',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976163/product_4_hfjmox.jpg',
      price: 8500,
      rating: 5.0,
      totalOrders: 21,
      description:
          'Luxurious chiffon fabric with stone work detailing. '
          'Custom stitching available. Ideal for bridal and formal events.',
      material: 'Chiffon',
      size: '3.0m x 1.2m',
    ),
  ];
}
