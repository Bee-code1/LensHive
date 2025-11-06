/// Product Model
/// Represents an eyewear product in the LensHive app
class Product {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;
  final String? category; // Men, Women, Kids
  final String? brand;
  final String? description;
  final bool isAvailable;
  final int? stock;
  final List<String>? colors;
  final List<String>? sizes;
  final List<String>? lensOptions; // Lens options (Frame only, Customize Lenses)
  final double? rating; // Product rating (0-5)
  final int? reviewCount; // Number of reviews
  final bool isBestseller; // Bestseller badge
  final bool isNew; // New product badge

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.currency = 'PKR',
    required this.imageUrl,
    this.category,
    this.brand,
    this.description,
    this.isAvailable = true,
    this.stock,
    this.colors,
    this.sizes,
    this.lensOptions,
    this.rating,
    this.reviewCount,
    this.isBestseller = false,
    this.isNew = false,
  });

  /// Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'PKR',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? json['primary_image'] ?? '',
      category: json['category'],
      brand: json['brand'],
      description: json['description'],
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
      stock: json['stock'],
      colors: json['colors'] != null 
          ? List<String>.from(json['colors']) 
          : null,
      sizes: json['sizes'] != null 
          ? List<String>.from(json['sizes']) 
          : null,
      lensOptions: json['lens_options'] != null 
          ? List<String>.from(json['lens_options']) 
          : null,
      rating: json['rating']?.toDouble(),
      reviewCount: json['review_count'] ?? json['reviewCount'],
      isBestseller: json['is_bestseller'] ?? json['isBestseller'] ?? false,
      isNew: json['is_new'] ?? json['isNew'] ?? false,
    );
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'image_url': imageUrl,
      'category': category,
      'brand': brand,
      'description': description,
      'is_available': isAvailable,
      'stock': stock,
      'colors': colors,
      'sizes': sizes,
      'lens_options': lensOptions,
      'rating': rating,
      'review_count': reviewCount,
      'is_bestseller': isBestseller,
      'is_new': isNew,
    };
  }

  /// Create a copy of Product with updated fields
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    String? imageUrl,
    String? category,
    String? brand,
    String? description,
    bool? isAvailable,
    int? stock,
    List<String>? colors,
    List<String>? sizes,
    List<String>? lensOptions,
    double? rating,
    int? reviewCount,
    bool? isBestseller,
    bool? isNew,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      stock: stock ?? this.stock,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      lensOptions: lensOptions ?? this.lensOptions,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isBestseller: isBestseller ?? this.isBestseller,
      isNew: isNew ?? this.isNew,
    );
  }

  /// Format price with currency
  String get formattedPrice {
    return '$currency ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
}

