/// Product Model
/// Represents an eyewear product in the LensHive app
class Product {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;
  final List<String>? images; // All product images for carousel
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
    this.images,
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
    // Helper function to safely convert to double
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }
    
    // Parse images array from backend
    // Note: URLs are already converted to absolute by API service
    List<String>? imagesList;
    if (json['images'] != null && json['images'] is List) {
      final imagesData = json['images'] as List;
      imagesList = imagesData.map((img) {
        if (img is Map) {
          // Extract image_url from image object (already absolute URL from API service)
          final imageUrl = img['image_url'] ?? img['image'];
          if (imageUrl != null && imageUrl.toString().isNotEmpty) {
            return imageUrl.toString();
          }
        }
        return null;
      }).where((url) => url != null).cast<String>().toList();
    }
    
    // Get primary image URL
    final primaryImage = json['primary_image'] ?? json['image_url'] ?? json['imageUrl'] ?? '';
    final primaryImageUrl = primaryImage.toString();
    
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: parseDouble(json['price']) ?? 0.0,
      currency: json['currency'] ?? 'PKR',
      imageUrl: primaryImageUrl.isNotEmpty ? primaryImageUrl : (imagesList?.isNotEmpty == true ? imagesList!.first : ''),
      images: imagesList,
      category: json['category'],
      brand: json['brand'],
      description: json['description'],
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
      stock: json['stock'] is int ? json['stock'] : (json['stock'] is String ? int.tryParse(json['stock']) : null),
      colors: json['colors'] != null 
          ? List<String>.from(json['colors']) 
          : null,
      sizes: json['sizes'] != null 
          ? List<String>.from(json['sizes']) 
          : null,
      lensOptions: json['lens_options'] != null 
          ? List<String>.from(json['lens_options']) 
          : null,
      rating: parseDouble(json['rating']),
      reviewCount: json['review_count'] is int 
          ? json['review_count'] 
          : (json['review_count'] is String ? int.tryParse(json['review_count']) : json['reviewCount']),
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
      'images': images,
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
    List<String>? images,
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
      images: images ?? this.images,
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

