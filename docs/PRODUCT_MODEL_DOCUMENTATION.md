# product_model.dart Documentation

**File Path:** `lenshive/lib/models/product_model.dart`

## Purpose
Defines the Product data model representing eyewear products in the LensHive catalog, with complete e-commerce fields including pricing, inventory, ratings, and badges.

## Key Concepts & Components

### 1. **E-Commerce Data Model**
```dart
class Product {
  final String id;
  final String name;
  final double price;
  // ... 20+ fields for complete product data
}
```
- **What it is**: Comprehensive product representation for online shopping
- **Purpose**: Store all product information needed for catalog and detail pages
- **Why so many fields**: E-commerce requires detailed product data for UX
- **Learning**: Real-world models are more complex than simple examples

### 2. **Type Safety with Dart**
```dart
final double price;          // Not String, actual number
final int? stock;            // Nullable integer
final List<String>? colors;  // Nullable list
```
- **Why types matter**: Prevents bugs, enables calculations, provides autocomplete
- **Nullable types**: Not all products have all fields
- **Collections**: Lists for multiple values (colors, sizes)

### 3. **Computed Properties**
```dart
String get formattedPrice {
  return '$currency ${price.toStringAsFixed(0)...}';
}
```
- **What it is**: A getter that calculates value on-demand
- **Why use it**: Centralized formatting logic, no duplicate code
- **Learning**: `get` keyword creates read-only property

### 4. **Default Values**
```dart
this.currency = 'PKR',
this.isAvailable = true,
```
- **Purpose**: Provide sensible defaults when not specified
- **Why needed**: Makes object creation simpler
- **Learning**: Constructor parameters can have default values

## Product Model Structure

### Complete Fields List

```dart
class Product {
  final String id;               // Unique identifier
  final String name;             // Product name
  final double price;            // Price in currency
  final String currency;         // Currency code (PKR, USD, etc.)
  final String imageUrl;         // Product image URL
  final String? category;        // Men, Women, Kids
  final String? brand;           // Brand name
  final String? description;     // Product description
  final bool isAvailable;        // In stock status
  final int? stock;              // Quantity available
  final List<String>? colors;    // Available colors
  final List<String>? sizes;     // Available sizes
  final double? rating;          // Average rating (0-5)
  final int? reviewCount;        // Number of reviews
  final bool isBestseller;       // Bestseller badge
  final bool isNew;              // New product badge
}
```

### Field-by-Field Breakdown

#### id (String)
```dart
final String id;
```
- **Format**: String identifier (e.g., "1", "prod_abc123")
- **Purpose**: Unique identifier for database/API
- **Usage**: API calls, cart operations, favorites
- **Why String**: Backend might use UUID or custom IDs
- **Required**: Yes

#### name (String)
```dart
final String name;
```
- **Example**: "Stylish Eyewear", "Classic Aviators"
- **Purpose**: Display product name in UI
- **Max length**: Usually 50-100 characters
- **Usage**: Product cards, detail page, search results
- **Required**: Yes

#### price (double)
```dart
final double price;
```
- **Format**: Decimal number (e.g., 12500.00)
- **Purpose**: Product price
- **Why double**: Supports cents/paisa (12500.50)
- **Currency**: Paired with `currency` field
- **Calculations**: Used for cart totals, discounts
- **Required**: Yes

#### currency (String)
```dart
final String currency;
```
- **Format**: Currency code (ISO 4217)
- **Examples**: "PKR", "USD", "EUR", "GBP"
- **Default**: "PKR" (Pakistani Rupee)
- **Purpose**: Display correct currency symbol
- **Why separate**: Multi-currency support
- **Required**: Yes (has default)

#### imageUrl (String)
```dart
final String imageUrl;
```
- **Format**: Full URL or path to image
- **Example**: "https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400"
- **Purpose**: Display product image
- **Fallback**: Error handler shows placeholder if image fails
- **Best practice**: Use CDN URLs with size parameters
- **Required**: Yes

#### category (String?)
```dart
final String? category;
```
- **Values**: "Men", "Women", "Kids"
- **Purpose**: Product categorization for filtering
- **Nullable**: Yes (some products might not have category)
- **Usage**: Category tabs, filtering, navigation
- **Case-sensitive**: Yes (consistent capitalization)
- **Required**: No

#### brand (String?)
```dart
final String? brand;
```
- **Examples**: "Ray-Ban", "Oakley", "Gucci"
- **Purpose**: Display brand name, brand filtering
- **Nullable**: Yes (generic/unbranded products)
- **Display**: Usually uppercase in UI
- **Required**: No

#### description (String?)
```dart
final String? description;
```
- **Format**: Free text, can be multi-line
- **Example**: "Classic stylish eyewear for men"
- **Purpose**: Product detail page description
- **Length**: Usually 100-500 characters
- **Nullable**: Yes
- **Required**: No

#### isAvailable (bool)
```dart
final bool isAvailable;
```
- **Values**: true or false
- **Default**: true
- **Purpose**: Show if product can be purchased
- **UI impact**: Grays out or hides unavailable products
- **Business logic**: Prevents adding to cart if false
- **Required**: Yes (has default)

#### stock (int?)
```dart
final int? stock;
```
- **Format**: Non-negative integer
- **Examples**: 0, 5, 100
- **Purpose**: Inventory management
- **0 = out of stock**: Should set isAvailable to false
- **Usage**: "Only 3 left!" messages, stock warnings
- **Nullable**: Yes (stock tracking might be disabled)
- **Required**: No

#### colors (List<String>?)
```dart
final List<String>? colors;
```
- **Format**: List of color names or hex codes
- **Example**: ["Black", "Blue", "Gold"] or ["#000000", "#0000FF", "#FFD700"]
- **Purpose**: Show available color options
- **UI**: Color picker, variant selection
- **Nullable**: Yes (not all products have color options)
- **Required**: No

#### sizes (List<String>?)
```dart
final List<String>? sizes;
```
- **Format**: List of size values
- **Example**: ["Small", "Medium", "Large"] or ["52mm", "54mm", "56mm"]
- **Purpose**: Frame size selection
- **UI**: Size selector dropdown/chips
- **Nullable**: Yes
- **Required**: No

#### rating (double?)
```dart
final double? rating;
```
- **Range**: 0.0 to 5.0
- **Format**: Decimal (e.g., 4.8, 4.5)
- **Purpose**: Display star rating
- **Calculation**: Average of all user ratings
- **Display**: Stars (★★★★☆)
- **Nullable**: Yes (new products without ratings)
- **Required**: No

#### reviewCount (int?)
```dart
final int? reviewCount;
```
- **Format**: Non-negative integer
- **Examples**: 0, 150, 1300
- **Purpose**: Show how many reviews product has
- **Display**: "(1,300 reviews)"
- **Trust indicator**: More reviews = more trustworthy rating
- **Nullable**: Yes
- **Required**: No

#### isBestseller (bool)
```dart
final bool isBestseller;
```
- **Values**: true or false
- **Default**: false
- **Purpose**: Show "Bestseller" badge on product card
- **Criteria**: High sales, popular item
- **UI**: Green badge with "Best Seller" text
- **Marketing**: Influences purchase decisions
- **Required**: Yes (has default)

#### isNew (bool)
```dart
final bool isNew;
```
- **Values**: true or false
- **Default**: false
- **Purpose**: Show "New" badge on product card
- **Criteria**: Recently added (e.g., last 30 days)
- **UI**: Red badge with "New" text
- **Marketing**: Attracts attention to new arrivals
- **Required**: Yes (has default)

## Constructor

```dart
Product({
  required this.id,
  required this.name,
  required this.price,
  this.currency = 'PKR',           // Default value
  required this.imageUrl,
  this.category,                   // Optional
  this.brand,                      // Optional
  this.description,                // Optional
  this.isAvailable = true,         // Default value
  this.stock,                      // Optional
  this.colors,                     // Optional
  this.sizes,                      // Optional
  this.rating,                     // Optional
  this.reviewCount,                // Optional
  this.isBestseller = false,       // Default value
  this.isNew = false,              // Default value
})
```

**Required fields**: id, name, price, imageUrl
**Optional fields**: All others
**Default values**: currency, isAvailable, isBestseller, isNew

## Methods

### 1. fromJson() - Factory Constructor

```dart
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id']?.toString() ?? '',
    name: json['name'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    currency: json['currency'] ?? 'PKR',
    imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
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
    rating: json['rating']?.toDouble(),
    reviewCount: json['review_count'] ?? json['reviewCount'],
    isBestseller: json['is_bestseller'] ?? json['isBestseller'] ?? false,
    isNew: json['is_new'] ?? json['isNew'] ?? false,
  );
}
```

**Key Features:**

#### Safe Type Conversion
```dart
json['id']?.toString()  // Convert any type to String
(json['price'] ?? 0).toDouble()  // Ensure double type
```

#### Field Name Flexibility
```dart
json['image_url'] ?? json['imageUrl']  // Handle snake_case and camelCase
json['is_available'] ?? json['isAvailable']
```
- Backend often uses snake_case
- Frontend uses camelCase
- Support both formats

#### List Conversion
```dart
json['colors'] != null 
    ? List<String>.from(json['colors']) 
    : null
```
- Check if field exists
- Convert JSON array to Dart List<String>
- Return null if not present

#### Null Defaults
```dart
json['name'] ?? ''  // Empty string if null
json['currency'] ?? 'PKR'  // Default currency
json['isBestseller'] ?? false  // Default to false
```

### 2. toJson() - Instance Method

```dart
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
    'rating': rating,
    'review_count': reviewCount,
    'is_bestseller': isBestseller,
    'is_new': isNew,
  };
}
```

**Purpose**: Convert Product to JSON for:
- API requests (creating/updating products)
- Local storage (favorites, cache)
- Logging/debugging

**Field Naming**: Uses snake_case for backend compatibility

### 3. copyWith() - Instance Method

```dart
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
    rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount,
    isBestseller: isBestseller ?? this.isBestseller,
    isNew: isNew ?? this.isNew,
  );
}
```

**Usage Examples:**
```dart
// Update price
final updatedProduct = product.copyWith(price: 15000);

// Mark as bestseller
final bestseller = product.copyWith(isBestseller: true);

// Update stock
final restocked = product.copyWith(stock: 50, isAvailable: true);

// Multiple updates
final updated = product.copyWith(
  price: 12000,
  rating: 4.8,
  reviewCount: 150,
);
```

### 4. formattedPrice - Computed Property

```dart
String get formattedPrice {
  return '$currency ${price.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  )}';
}
```

**Purpose**: Format price with currency and thousand separators

**How it works:**
1. Convert price to string without decimals: `toStringAsFixed(0)`
2. Add thousand separators using regex
3. Prepend currency code

**Examples:**
```dart
Product(price: 12500, currency: 'PKR').formattedPrice
// Output: "PKR 12,500"

Product(price: 1234567, currency: 'USD').formattedPrice
// Output: "USD 1,234,567"
```

**Regex Explanation:**
```dart
r'(\d{1,3})(?=(\d{3})+(?!\d))'
```
- `\d{1,3}`: Match 1-3 digits
- `(?=(\d{3})+(?!\d))`: Followed by groups of 3 digits
- **Result**: Finds positions to insert commas

**Usage in UI:**
```dart
Text(product.formattedPrice)  // Display formatted price
```

## Mock Data Example

```dart
Product(
  id: '1',
  name: 'Stylish Eyewear',
  price: 12500,
  currency: 'PKR',
  imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400',
  category: 'Men',
  brand: 'Ray-Ban',
  description: 'Classic stylish eyewear for men',
  isAvailable: true,
  stock: 10,
  colors: ['Black', 'Blue', 'Gold'],
  sizes: ['52mm', '54mm', '56mm'],
  rating: 4.8,
  reviewCount: 1300,
  isBestseller: false,
  isNew: false,
)
```

## Data Flow

### Loading Products
```
1. HomeProvider.loadProducts() called
2. API returns JSON array of products
3. Each JSON object converted via Product.fromJson()
4. List<Product> stored in HomeState
5. Products filtered by category
6. Products displayed in ProductGrid
```

### Display in UI
```
ProductCard
  ├─ Image (product.imageUrl)
  ├─ Name (product.name)
  ├─ Brand (product.brand?.toUpperCase())
  ├─ Price (product.formattedPrice)
  ├─ Rating (★ product.rating)
  ├─ Badges
  │   ├─ Bestseller (if product.isBestseller)
  │   └─ New (if product.isNew)
  └─ Buttons
      ├─ Try On
      └─ Add to Cart (if product.isAvailable)
```

## Integration Points

### With HomeProvider
```dart
class HomeState {
  final List<Product> products;
  final List<Product> filteredProducts;
}

// Usage
final products = ref.watch(homeProvider).filteredProducts;
```

### With ProductCard Widget
```dart
EnhancedProductCard(
  product: product,
  onTap: () => navigateToDetail(product.id),
  onAddToCart: () => addToCart(product),
)
```

### With Cart (Future)
```dart
class CartItem {
  final Product product;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
}
```

## Common Patterns

### Safe Access to Optional Fields
```dart
// Brand display
Text(product.brand ?? 'Generic')

// Rating display
if (product.rating != null) {
  RatingStars(rating: product.rating!)
}

// Color selection
if (product.colors != null && product.colors!.isNotEmpty) {
  ColorPicker(colors: product.colors!)
}
```

### Filtering Products
```dart
// By category
final menProducts = products.where((p) => p.category == 'Men').toList();

// By availability
final availableProducts = products.where((p) => p.isAvailable).toList();

// By bestseller
final bestsellers = products.where((p) => p.isBestseller).toList();

// By price range
final affordable = products.where((p) => p.price < 15000).toList();
```

### Sorting Products
```dart
// By price (low to high)
products.sort((a, b) => a.price.compareTo(b.price));

// By rating (high to low)
products.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

// By name (alphabetical)
products.sort((a, b) => a.name.compareTo(b.name));
```

## Best Practices

### 1. Always Format Prices
```dart
// ❌ Bad
Text('${product.price} ${product.currency}')

// ✅ Good
Text(product.formattedPrice)
```

### 2. Handle Nullable Fields
```dart
// ❌ Bad
Text(product.brand.toUpperCase())  // Crashes if null

// ✅ Good
Text(product.brand?.toUpperCase() ?? 'GENERIC')
```

### 3. Check Availability
```dart
// ❌ Bad
ElevatedButton(onPressed: () => addToCart(product))

// ✅ Good
ElevatedButton(
  onPressed: product.isAvailable ? () => addToCart(product) : null,
)
```

### 4. Validate Stock
```dart
// Check stock before adding to cart
if (product.stock != null && product.stock! < quantity) {
  showError('Not enough stock');
  return;
}
```

## Future Enhancements
- Add discount/sale price fields
- Add product variants (different colors/sizes as separate products)
- Add image gallery (multiple images)
- Add product specifications list
- Add related products field
- Add wishlist status
- Add purchase history
- Add AR model URL for try-on feature
- Implement Freezed package for immutability
- Add product search tags/keywords

## Related Files
- **home_provider.dart**: Manages product list
- **enhanced_product_card.dart**: Displays product
- **home_screen.dart**: Shows product grid
- Future: **product_detail_screen.dart**, **cart_provider.dart**

## Summary

The Product model is essential for:
- ✅ Type-safe product data
- ✅ E-commerce functionality
- ✅ Rich product information
- ✅ Filtering and sorting
- ✅ UI rendering
- ✅ Business logic (availability, pricing)

It provides a comprehensive structure for managing eyewear products in the LensHive catalog with all necessary fields for a complete shopping experience.

