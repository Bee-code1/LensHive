import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product_model.dart';

/// Enhanced Product Card Widget
/// Professional product card with brand, rating, badges, and cart icon
class EnhancedProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onTryOn;
  final VoidCallback? onAddToCart;

  const EnhancedProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onTryOn,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with badges and Try On button
            Expanded(
              child: Stack(
                children: [
                  // Image Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholder();
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return _buildPlaceholder();
                              },
                            )
                          : _buildPlaceholder(),
                    ),
                  ),

                  // Bestseller Badge (top-left)
                  if (product.isBestseller)
                    Positioned(
                      top: 8.r,
                      left: 8.r,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.r,
                          vertical: 4.r,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'Bestseller',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.r,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // New Badge (top-left, below bestseller if both exist)
                  if (product.isNew)
                    Positioned(
                      top: product.isBestseller ? 36.r : 8.r,
                      left: 8.r,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.r,
                          vertical: 4.r,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.r,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Try On Button (bottom-center)
                  Positioned(
                    bottom: 10.r,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: onTryOn ?? () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.r,
                            vertical: 8.r,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[800]!.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16.r,
                              ),
                              SizedBox(width: 6.r),
                              Text(
                                'Try On',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.r,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details Section
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14.r,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.r),

                  // Brand Name
                  if (product.brand != null)
                    Text(
                      product.brand!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.r,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),

                  SizedBox(height: 8.r),

                  // Price and Cart Icon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        product.formattedPrice,
                        style: TextStyle(
                          fontSize: 15.r,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),

                      // Add to Cart Button
                      GestureDetector(
                        onTap: onAddToCart ?? () {},
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 18.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 50.r,
        color: Colors.grey[300],
      ),
    );
  }
}

