import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product_model.dart';
import '../constants/app_colors.dart';

/// Product Detail Screen
/// Displays detailed information about a selected product
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  // Global Text Size Constants - Professional Typography Scale
  static final double _headingLarge = 20.r;      // Product name
  static final double _headingMedium = 18.r;     // Price
  static final double _headingSmall = 16.r;      // Section titles
  static final double _bodyLarge = 15.r;         // Buttons
  static final double _bodyMedium = 14.r;        // Options, selections
  static final double _bodySmall = 13.r;         // Descriptions, details
  static final double _captionText = 11.r;       // Small info, badges
  
  String? selectedColor;
  String? selectedSize;
  String? selectedLensOption;
  bool isDescriptionExpanded = false;
  bool isShippingExpanded = false;
  bool isSpecsExpanded = false;
  int currentImageIndex = 0;
  late PageController _pageController;
  
  // Customize Lenses Dialog State
  String? selectedLensType;
  final List<String> lensTypes = [
    'Blue Block',
    'Transition',
    'Polarized',
    'Photochromic',
    'Anti-Glare',
    'Thin & Light',
  ];
  
  // Prescription Upload State
  File? prescriptionImage;
  String? prescriptionPath;
  final ImagePicker _picker = ImagePicker();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize PageController for image carousel
    _pageController = PageController(initialPage: 0);
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    
    // Set default selections (with fallbacks if data is missing)
    if (widget.product.colors != null && widget.product.colors!.isNotEmpty) {
      selectedColor = widget.product.colors!.first;
    } else {
      selectedColor = 'Black'; // Default color if none provided
    }
    
    if (widget.product.sizes != null && widget.product.sizes!.isNotEmpty) {
      selectedSize = widget.product.sizes!.first;
    } else {
      selectedSize = 'Medium'; // Default size if none provided
    }
    
    // Smart default for lens option based on product type
    if (widget.product.lensOptions != null &&
        widget.product.lensOptions!.isNotEmpty) {
      selectedLensOption = widget.product.lensOptions!.first;
    } else {
      // Check if this is sunglasses or spectacles
      final isSunglasses = _isSunglassesProduct();
      if (isSunglasses) {
        // Sunglasses: Default to "Frame only"
        selectedLensOption = 'Frame only';
      } else {
        // Spectacles: Default to "Customize Lenses" (enabled by default)
        selectedLensOption = 'Customize Lenses';
      }
    }
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  // Helper method to detect if product is sunglasses (used in initState)
  bool _isSunglassesProduct() {
    // Check product name for sunglasses keywords
    final name = widget.product.name.toLowerCase();
    if (name.contains('sunglass') || 
        name.contains('sun glass') ||
        name.contains('shades')) {
      return true;
    }
    
    // Check product description for sunglasses keywords
    final description = (widget.product.description ?? '').toLowerCase();
    if (description.contains('sunglass') || 
        description.contains('sun protection') ||
        description.contains('uv protection') && description.contains('outdoor')) {
      return true;
    }
    
    // Check product category if available
    final category = (widget.product.category ?? '').toLowerCase();
    if (category.contains('sunglass')) {
      return true;
    }
    
    // Default: treat as spectacles (eyeglasses) - enable customization
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
        child: Column(
          children: [
            // Top Bar with Back and Wishlist buttons
            _buildTopBar(isDark),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      // Enhanced Product Image with Carousel
                    _buildProductImage(),

                    // Product Info Section
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                fontSize: _headingLarge,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),

                            SizedBox(height: 12.r),

                            // Price and Stock Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Price
                                Text(
                                  widget.product.formattedPrice,
                                  style: TextStyle(
                                    fontSize: _headingMedium,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),

                                SizedBox(width: 12.r),

                                // Stock Information
                                if (widget.product.stock != null &&
                                    widget.product.stock! > 0)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.r,
                                      vertical: 4.r,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      '${widget.product.stock} in stock',
                                      style: TextStyle(
                                        fontSize: _captionText,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(height: 24.r),

                          // Frame Color Section - ALWAYS VISIBLE
                          _buildFrameColorSection(isDark),

                            SizedBox(height: 28.r),

                          // Size/Fit Section - ALWAYS VISIBLE
                          _buildSizeFitSection(isDark),

                            SizedBox(height: 28.r),

                            // Lens Selection Section - ALWAYS VISIBLE
                            _buildLensSelectionSection(isDark),

                            SizedBox(height: 20.r),

                            // Description Section
                            if (widget.product.description != null)
                              _buildDescriptionSection(isDark),

                            SizedBox(height: 16.r),

                            // Shipping & Returns Section
                            _buildShippingSection(isDark),

                            SizedBox(height: 100.r), // Space for bottom buttons
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),

      // Bottom Buttons (Try On + Add to Cart)
      bottomNavigationBar: _buildBottomButtons(isDark),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 8.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Back Button
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
              size: 24.r,
            ),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Get all images - use images list if available, otherwise use single imageUrl
    final List<String> imageUrls = [];
    if (widget.product.images != null && widget.product.images!.isNotEmpty) {
      imageUrls.addAll(widget.product.images!);
    } else if (widget.product.imageUrl.isNotEmpty) {
      imageUrls.add(widget.product.imageUrl);
    }
    
    // If no images, show placeholder
    if (imageUrls.isEmpty) {
      return Container(
        width: double.infinity,
        height: 300.r,
        margin: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark 
              ? const Color(0xFF1C1C1E)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 60.r,
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
      );
    }
    
    return Container(
      width: double.infinity,
      height: 300.r,
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark 
            ? const Color(0xFF1C1C1E)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Image Carousel with PageView
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentImageIndex = index;
                });
              },
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'product-${widget.product.id}-$index',
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 60.r,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            
            // Image Indicators (dots) - only show if more than 1 image
            if (imageUrls.length > 1)
              Positioned(
                bottom: 12.r,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageUrls.length,
                    (index) => Container(
                      width: 8.r,
                      height: 8.r,
                      margin: EdgeInsets.symmetric(horizontal: 4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentImageIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameColorSection(bool isDark) {
    // Use product colors if available, otherwise use default colors
    final colors = (widget.product.colors != null && widget.product.colors!.isNotEmpty)
        ? widget.product.colors!
        : ['Black', 'Silver', 'Gray', 'Brown']; // Default colors
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frame Color',
          style: TextStyle(
            fontSize: _headingSmall,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        SizedBox(height: 12.r),
        Row(
          children: colors.map((color) {
            final isSelected = selectedColor == color;
            return Padding(
              padding: EdgeInsets.only(right: 12.r),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: _getColorFromName(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                          : (isDark ? Colors.white24 : Colors.grey[300]!),
                      width: isSelected ? 2.5.r : 1.5.r,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: _getContrastColor(_getColorFromName(color)),
                          size: 18.r,
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeFitSection(bool isDark) {
    // Use product sizes if available, otherwise use default sizes
    final sizes = (widget.product.sizes != null && widget.product.sizes!.isNotEmpty)
        ? widget.product.sizes!
        : ['Small', 'Medium', 'Large']; // Default sizes
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size/Fit',
          style: TextStyle(
            fontSize: _headingSmall,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        SizedBox(height: 12.r),
        Row(
          children: sizes.map((size) {
            final isSelected = selectedSize == size;
            final isLast = size == sizes.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 10.r),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = size;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 12.r),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark
                              ? AppColors.primaryDarkMode
                              : AppColors.primary)
                          : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      size,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLensSelectionSection(bool isDark) {
    // Determine if this is a sunglasses product
    final isSunglasses = _isSunglassesProduct();
    
    // Use product lens options if available, otherwise use smart defaults based on product type
    List<String> lensOptions;
    
    if (widget.product.lensOptions != null && widget.product.lensOptions!.isNotEmpty) {
      // Use product-specific lens options
      lensOptions = widget.product.lensOptions!;
    } else {
      // Smart defaults based on product type
      if (isSunglasses) {
        // Sunglasses: Only "Frame only" option (no customization)
        lensOptions = ['Frame only'];
      } else {
        // Spectacles/Eyeglasses: Both options available, Customize enabled by default
        lensOptions = ['Frame only', 'Customize Lenses'];
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lens Selection',
          style: TextStyle(
            fontSize: _headingSmall,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        SizedBox(height: 12.r),
        Column(
          children: lensOptions.map((option) {
            final isSelected = selectedLensOption == option;
            final isCustomize = option.toLowerCase().contains('customize');
            return Padding(
              padding: EdgeInsets.only(bottom: 10.r),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLensOption = option;
                  });
                  // Show customize dialog if "Customize Lenses" is selected
                  if (isCustomize) {
                    _showCustomizeLensesDialog();
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 14.r,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppColors.primaryDarkMode
                            : AppColors.primary)
                        : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: _bodyMedium,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      if (isCustomize)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.r,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Show Customize Lenses Dialog
  void _showCustomizeLensesDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 10.r),
                width: 36.r,
                height: 4.r,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Customize Lenses',
                      style: TextStyle(
                        fontSize: _headingMedium,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        size: 22.r,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              Divider(height: 1, color: isDark ? Colors.white12 : Colors.grey[200]),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lens Type & Coatings
                      Text(
                        'Lens Type',
                        style: TextStyle(
                          fontSize: _bodyLarge,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 12.r),
                      
                      // Lens Type Grid - Compact 3-column layout
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.r,
                          mainAxisSpacing: 8.r,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: lensTypes.length,
                        itemBuilder: (context, index) {
                          final lensType = lensTypes[index];
                          final isSelected = selectedLensType == lensType;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedLensType = lensType;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                        ? AppColors.primaryDarkMode
                                        : AppColors.primary)
                                    : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: Text(
                                  lensType,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _captionText,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 20.r),
                      
                      // Upload Prescription
                      Text(
                        'Prescription',
                        style: TextStyle(
                          fontSize: _bodyLarge,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      SizedBox(height: 6.r),
                      
                      // Instruction text
                      Text(
                        'Upload JPG/PNG (Max 5MB)',
                        style: TextStyle(
                          fontSize: _captionText,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10.r),
                      
                      // Upload buttons
                      Row(
                        children: [
                          // Camera button
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _pickPrescriptionImage(ImageSource.camera, setModalState);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.r),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 18.r,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    SizedBox(width: 6.r),
                                    Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontSize: _bodySmall,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(width: 10.r),
                          
                          // Gallery button
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _pickPrescriptionImage(ImageSource.gallery, setModalState);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.r),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_library,
                                      size: 18.r,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    SizedBox(width: 6.r),
                                    Text(
                                      'Gallery',
                                      style: TextStyle(
                                        fontSize: _bodySmall,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Show uploaded image preview
                      if (prescriptionImage != null) ...[
                        SizedBox(height: 12.r),
                        Container(
                          height: 120.r,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isDark ? Colors.white24 : Colors.grey[300]!,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Stack(
                              children: [
                                Image.file(
                                  prescriptionImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Positioned(
                                  top: 4.r,
                                  right: 4.r,
                                  child: GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        prescriptionImage = null;
                                        prescriptionPath = null;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4.r),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 16.r,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      
                      SizedBox(height: 16.r),
                    ],
                  ),
                ),
              ),
              
              // Done Button
              Padding(
                padding: EdgeInsets.all(16.r),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (selectedLensType != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lens customization saved: $selectedLensType'),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48.r),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: _bodyLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isDescriptionExpanded = !isDescriptionExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Description',
                style: TextStyle(
                  fontSize: _headingSmall,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Icon(
                isDescriptionExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Theme.of(context).iconTheme.color,
                size: 22.r,
              ),
            ],
          ),
        ),
        if (isDescriptionExpanded)
          Padding(
            padding: EdgeInsets.only(top: 10.r),
            child: Text(
              widget.product.description ?? 'No description available.',
              style: TextStyle(
                fontSize: _bodySmall,
                color: Theme.of(context).textTheme.bodySmall?.color,
                height: 1.5,
              ),
            ),
          ),
        SizedBox(height: 12.r),
        Divider(height: 1, color: isDark ? Colors.white12 : Colors.grey[300]),
      ],
    );
  }

  Widget _buildShippingSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isShippingExpanded = !isShippingExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping & Returns',
                style: TextStyle(
                  fontSize: _headingSmall,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Icon(
                isShippingExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Theme.of(context).iconTheme.color,
                size: 22.r,
              ),
            ],
          ),
        ),
        if (isShippingExpanded)
          Padding(
            padding: EdgeInsets.only(top: 10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Free shipping on orders over PKR 5,000',
                  style: TextStyle(
                    fontSize: _bodySmall,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 4.r),
                Text(
                  '• Delivery within 3-5 business days',
                  style: TextStyle(
                    fontSize: _bodySmall,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 4.r),
                Text(
                  '• 30-day return policy',
                  style: TextStyle(
                    fontSize: _bodySmall,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBottomButtons(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Try On Button
            Container(
              width: 50.r,
              height: 50.r,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AR Try-On coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Icon(
                    Icons.face_retouching_natural,
                    color: Theme.of(context).iconTheme.color,
                    size: 24.r,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 12.r),
            
            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.product.name} added to cart!'),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: _bodyLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Prescription Image Picker Methods
  Future<void> _pickPrescriptionImage(ImageSource source, StateSetter setModalState) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Compress to save space
        maxWidth: 1920,
        maxHeight: 1920,
      );
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        
        // Check file size (max 5MB)
        final fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size must be less than 5MB'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }
        
        // Save to local storage
        final savedPath = await _savePrescriptionLocally(file);
        
        if (savedPath != null) {
          setState(() {
            prescriptionImage = file;
            prescriptionPath = savedPath;
          });
          
          setModalState(() {
            prescriptionImage = file;
            prescriptionPath = savedPath;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Prescription uploaded successfully!'),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
  Future<String?> _savePrescriptionLocally(File imageFile) async {
    try {
      // Get app's local directory
      final directory = await getApplicationDocumentsDirectory();
      final prescriptionFolder = Directory('${directory.path}/prescriptions');
      
      // Create folder if doesn't exist
      if (!await prescriptionFolder.exists()) {
        await prescriptionFolder.create(recursive: true);
      }
      
      // Create unique filename with product ID and timestamp
      final fileName = 'prescription_${widget.product.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${prescriptionFolder.path}/$fileName';
      
      // Copy image to local folder
      await imageFile.copy(savedPath);
      
      return savedPath;
    } catch (e) {
      print('Error saving prescription: $e');
      return null;
    }
  }

  // Helper method to get color from color name
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'obsidian':
      case 'black':
        return const Color(0xFF1A1A1A);
      case 'silver':
      case 'grey':
      case 'gray':
        return const Color(0xFF9E9E9E);
      case 'rose':
      case 'pink':
        return const Color(0xFFE8B4B8);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'blue':
        return const Color(0xFF2196F3);
      case 'brown':
        return const Color(0xFF8D6E63);
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'white':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }
  
  // Helper method to get contrast color for text/icons on colored backgrounds
  Color _getContrastColor(Color backgroundColor) {
    // Calculate luminance
    final luminance = backgroundColor.computeLuminance();
    // Return white for dark colors, black for light colors
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

