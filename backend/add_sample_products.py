"""
Sample Product Data Script
Run this script to add sample products with all the new fields for testing
the Product Detail Screen.

Usage:
    python manage.py shell < add_sample_products.py
    
Or:
    python manage.py shell
    >>> exec(open('add_sample_products.py').read())
"""

from products.models import Product, ProductImage

# Sample products data
sample_products = [
    {
        'name': 'AURA Vision Pro',
        'description': 'Premium eyewear with advanced lens technology. Features durable acetate frames with spring hinges for maximum comfort. Perfect for daily wear with a timeless design that suits any face shape. Anti-glare coating included.',
        'price': 1500.00,
        'stock': 12,
        'category': 'Unisex',
        'brand': 'AURA',
        'frame_colors': 'Obsidian,Silver,Gray,Rose',
        'sizes': 'Small,Medium,Large',
        'lens_options': 'Frame only,Customize Lenses',
        'rating': 4.8,
        'review_count': 234,
        'is_bestseller': True,
        'is_new': False,
        'is_available': True,
    },
    {
        'name': 'Classic Aviator',
        'description': 'Iconic aviator style with modern refinements. Lightweight metal frame with adjustable nose pads. UV400 protection lenses block harmful rays. Includes premium hard case and cleaning cloth.',
        'price': 2500.00,
        'stock': 25,
        'category': 'Men',
        'brand': 'Classic',
        'frame_colors': 'Gold,Silver,Black',
        'sizes': 'Medium,Large',
        'lens_options': 'Frame only,Customize Lenses',
        'rating': 4.6,
        'review_count': 156,
        'is_bestseller': True,
        'is_new': False,
        'is_available': True,
    },
    {
        'name': 'Luna Cat Eye',
        'description': 'Elegant cat-eye frames that add sophistication to any look. Handcrafted acetate with subtle color gradients. Perfect for fashion-forward individuals. Features flexible hinges for all-day comfort.',
        'price': 1800.00,
        'stock': 8,
        'category': 'Women',
        'brand': 'Luna',
        'frame_colors': 'Rose,Pink,Brown,Black',
        'sizes': 'Small,Medium',
        'lens_options': 'Frame only,Customize Lenses',
        'rating': 4.9,
        'review_count': 89,
        'is_bestseller': False,
        'is_new': True,
        'is_available': True,
    },
    {
        'name': 'Sport Elite',
        'description': 'High-performance sports eyewear with wraparound design. Impact-resistant polycarbonate lenses provide maximum protection. Rubber nose pads and temple tips prevent slipping during activity. Perfect for athletes and active lifestyles.',
        'price': 3200.00,
        'stock': 15,
        'category': 'Unisex',
        'brand': 'Elite',
        'frame_colors': 'Black,Blue,Red',
        'sizes': 'Medium,Large',
        'lens_options': 'Frame only,Customize Lenses',
        'rating': 4.7,
        'review_count': 178,
        'is_bestseller': True,
        'is_new': False,
        'is_available': True,
    },
    {
        'name': 'Kids Rainbow',
        'description': 'Durable and colorful frames designed specifically for children. Flexible frame material that withstands daily wear and tear. Adjustable temples grow with your child. Comes with fun character case.',
        'price': 1200.00,
        'stock': 30,
        'category': 'Kids',
        'brand': 'Rainbow',
        'frame_colors': 'Blue,Pink,Green,Red',
        'sizes': 'Small',
        'lens_options': 'Frame only,Customize Lenses',
        'rating': 4.5,
        'review_count': 67,
        'is_bestseller': False,
        'is_new': True,
        'is_available': True,
    },
    {
        'name': 'Vintage Round',
        'description': 'Retro-inspired round frames with modern lens technology. Thin metal construction offers a lightweight feel. Ideal for those seeking a classic, intellectual look. Available with blue light filtering.',
        'price': 1650.00,
        'stock': 5,
        'category': 'Unisex',
        'brand': 'Vintage',
        'frame_colors': 'Gold,Silver,Bronze',
        'sizes': 'Small,Medium',
        'lens_options': 'Frame only,Customize Lenses',
        'rating': 4.4,
        'review_count': 123,
        'is_bestseller': False,
        'is_new': False,
        'is_available': True,
    },
]

def add_sample_products():
    """Add sample products to the database"""
    created_count = 0
    updated_count = 0
    
    for product_data in sample_products:
        # Check if product already exists by name
        product, created = Product.objects.update_or_create(
            name=product_data['name'],
            defaults=product_data
        )
        
        if created:
            created_count += 1
            print(f"✅ Created: {product.name} - PKR {product.price}")
        else:
            updated_count += 1
            print(f"🔄 Updated: {product.name} - PKR {product.price}")
    
    print(f"\n{'='*50}")
    print(f"Summary:")
    print(f"  Products Created: {created_count}")
    print(f"  Products Updated: {updated_count}")
    print(f"  Total Products: {Product.objects.count()}")
    print(f"{'='*50}")
    
    print("\n💡 Note: Don't forget to add product images via Django Admin!")
    print("   Go to: http://localhost:8000/admin/products/productimage/")

if __name__ == '__main__':
    add_sample_products()

