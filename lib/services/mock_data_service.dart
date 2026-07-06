import '../models/tailor_model.dart';
import '../models/product_model.dart';

class MockDataService {
  MockDataService._();

  static List<TailorModel> getTailors() => [
    TailorModel(
      id: 't1',
      shopName: 'Stitch & Style',
      ownerName: 'Ahmed Raza',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976163/tailor_1_bllexs.jpg',
      shopImages: [
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976163/tailor_1_bllexs.jpg',
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_2_clc9iw.jpg',
      ],
      rating: 5.0,
      address: 'Shop 12, Liberty Market, Lahore, Punjab',
      experience: '10 years',
      workingHours: 'Mon–Sat, 9:00 AM – 8:00 PM',
      phone: '03001234567',
      reviews: [
        {
          'name': 'Sara K.',
          'stars': 5,
          'comment': 'Excellent work, delivered on time!',
        },
        {
          'name': 'Ali B.',
          'stars': 5,
          'comment': 'Best tailor in Lahore, very professional.',
        },
      ],
    ),
    TailorModel(
      id: 't2',
      shopName: 'The Fitted Look',
      ownerName: 'Fatima Noor',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_2_clc9iw.jpg',
      shopImages: [
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_2_clc9iw.jpg',
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976163/tailor_1_bllexs.jpg',
      ],
      rating: 4.8,
      address: 'Block 5, Gulshan-e-Iqbal, Karachi, Sindh',
      experience: '7 years',
      workingHours: 'Mon–Sun, 10:00 AM – 7:00 PM',
      phone: '03111234567',
      reviews: [
        {
          'name': 'Hina M.',
          'stars': 5,
          'comment': 'Amazing stitching quality!',
        },
        {
          'name': 'Usman T.',
          'stars': 4,
          'comment': 'Fast turnaround, very happy.',
        },
      ],
    ),
    TailorModel(
      id: 't3',
      shopName: 'Prestige Tailors',
      ownerName: 'Bilal Hussain',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_3_od7lzp.jpg',
      shopImages: [
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_3_od7lzp.jpg',
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_4_nlnvmj.jpg',
      ],
      rating: 4.9,
      address: 'F-7 Markaz, Islamabad, ICT',
      experience: '12 years',
      workingHours: 'Mon–Sat, 9:00 AM – 6:00 PM',
      phone: '03211234567',
      reviews: [
        {
          'name': 'Zara A.',
          'stars': 5,
          'comment': 'Premium quality, worth every rupee.',
        },
        {
          'name': 'Kamran S.',
          'stars': 5,
          'comment': 'Best bespoke tailoring in Islamabad.',
        },
      ],
    ),
    TailorModel(
      id: 't4',
      shopName: 'Thread & Needle Co.',
      ownerName: 'Imran Sheikh',
      imagePath:
          'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_4_nlnvmj.jpg',
      shopImages: [
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976164/tailor_4_nlnvmj.jpg',
        'https://res.cloudinary.com/yhocqhzs/image/upload/v1782976163/tailor_1_bllexs.jpg',
      ],
      rating: 4.7,
      address: 'D-Ground, Faisalabad, Punjab',
      experience: '5 years',
      workingHours: 'Mon–Sat, 8:00 AM – 9:00 PM',
      phone: '03411234567',
      reviews: [
        {
          'name': 'Nadia R.',
          'stars': 5,
          'comment': 'Very affordable and great quality.',
        },
        {
          'name': 'Tariq L.',
          'stars': 4,
          'comment': 'Good work, accepts bulk orders.',
        },
      ],
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
