#!/usr/bin/env python
"""
Script to update an existing product with color, size, and lens options
Run: python manage.py shell < update_product_with_options.py
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'lenshive_backend.settings')
django.setup()

from products.models import Product

# Get the product you want to update (change the ID or name as needed)
try:
    # Option 1: Update by ID
    product = Product.objects.get(id=1)  # Change ID as needed
    
    # Option 2: Or update by name
    # product = Product.objects.get(name='Stylish Eyewear')
    
    # Update the product with the required fields
    product.brand = 'AURA'
    product.category = 'Unisex'
    product.frame_colors = 'Obsidian,Silver,Gray,Rose'
    product.sizes = 'Small,Medium,Large'
    product.lens_options = 'Frame only,Customize Lenses'
    product.rating = 4.5
    product.review_count = 218
    product.is_bestseller = True
    product.is_available = True
    
    # Optional: Update other fields
    product.name = 'AURA Vision Pro'
    product.price = 1500.00  # PKR 1,500 (or 349.99 for USD)
    product.stock = 12
    product.description = 'Premium eyewear with advanced lens technology. Features durable acetate frames with spring hinges for maximum comfort.'
    
    product.save()
    
    print(f"✅ Successfully updated product: {product.name}")
    print(f"   ID: {product.id}")
    print(f"   Brand: {product.brand}")
    print(f"   Colors: {product.frame_colors}")
    print(f"   Sizes: {product.sizes}")
    print(f"   Lens Options: {product.lens_options}")
    print(f"   Price: PKR {product.price}")
    print(f"   Stock: {product.stock}")
    
except Product.DoesNotExist:
    print("❌ Product not found. Please check the ID or name.")
    print("\nAvailable products:")
    for p in Product.objects.all():
        print(f"   - ID: {p.id}, Name: {p.name}")

