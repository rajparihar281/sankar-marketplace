import 'dart:convert';
import '../../core/constants/app_constants.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final List<String> images;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.discountPercentage = 0.0,
    this.rating = 4.5,
    this.stock = 25,
    this.brand = 'Sankar Precision',
    required this.thumbnail,
    List<String>? images,
    this.warrantyInformation = '1 Year Official Sankar Warranty',
    this.shippingInformation = 'Ships in 1-2 business days',
    this.availabilityStatus = 'In Stock',
  }) : images = images ?? (thumbnail.isNotEmpty ? [thumbnail] : []);

  double get discountedPrice {
    if (discountPercentage <= 0) return price;
    return price * (1 - (discountPercentage / 100));
  }

  String get formattedPrice => AppConstants.formatPrice(price);
  String get formattedDiscountedPrice => AppConstants.formatPrice(discountedPrice);

  bool get isInStock => stock > 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'thumbnail': thumbnail,
      'images': images,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    // Parse price safely
    double parsedPrice = 0.0;
    if (map['price'] is num) {
      parsedPrice = (map['price'] as num).toDouble();
    } else if (map['price'] != null) {
      parsedPrice = double.tryParse(map['price'].toString()) ?? 0.0;
    }

    final id = map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0;

    // Convert external dummyjson USD prices into realistic INR values
    if (id < 100 && parsedPrice < 1000) {
      parsedPrice = (parsedPrice * 80.0).roundToDouble();
    }

    // Parse discount
    double parsedDiscount = 0.0;
    if (map['discountPercentage'] is num) {
      parsedDiscount = (map['discountPercentage'] as num).toDouble();
    }

    // Parse rating
    double parsedRating = 4.0;
    if (map['rating'] is num) {
      parsedRating = (map['rating'] as num).toDouble();
    } else if (map['rating'] is Map && map['rating']['rate'] != null) {
      parsedRating = (map['rating']['rate'] as num).toDouble();
    }

    // Parse stock
    int parsedStock = 20;
    if (map['stock'] is int) {
      parsedStock = map['stock'];
    } else if (map['stock'] is num) {
      parsedStock = (map['stock'] as num).toInt();
    }

    // Parse images
    List<String> parsedImages = [];
    if (map['images'] is List) {
      parsedImages = List<String>.from(
        (map['images'] as List).map((e) => e.toString()),
      );
    }
    final thumb = map['thumbnail']?.toString() ??
        map['image']?.toString() ??
        (parsedImages.isNotEmpty ? parsedImages.first : '');

    if (parsedImages.isEmpty && thumb.isNotEmpty) {
      parsedImages = [thumb];
    }

    return ProductModel(
      id: id,
      title: map['title']?.toString() ?? 'Industrial Component',
      description: map['description']?.toString() ?? 'Precision industrial product specification.',
      category: map['category']?.toString() ?? 'General',
      price: parsedPrice,
      discountPercentage: parsedDiscount,
      rating: parsedRating,
      stock: parsedStock,
      brand: map['brand']?.toString() ?? 'Sankar Solutions',
      thumbnail: thumb,
      images: parsedImages,
      warrantyInformation: map['warrantyInformation']?.toString() ??
          '1 Year Sankar Warranty Included',
      shippingInformation: map['shippingInformation']?.toString() ??
          'Express delivery across India',
      availabilityStatus: map['availabilityStatus']?.toString() ??
          (parsedStock > 0 ? 'In Stock' : 'Out of Stock'),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
