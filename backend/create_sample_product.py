#!/usr/bin/env python
"""
Simple script to create a sample product via Django shell
Run: python manage.py shell < create_sample_product.py
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'lenshive_backend.settings')
django.setup()

from products.models import Product

# Create a sample product
product = Product.objects.create(
    name='AURA Vision Pro',
    description='Premium eyewear with advanced lens technology. Features durable acetate frames with spring hinges for maximum comfort. Perfect for daily wear with a timeless design that suits any face shape.',
    price=1500.00,
    stock=12,
    category='Unisex',
    brand='AURA',
    frame_colors='Obsidian,Silver,Gray,Rose',
    sizes='Small,Medium,Large',
    lens_options='Frame only,Customize Lenses',
    rating=4.8,
    review_count=234,
    is_bestseller=True,
    is_new=False,
    is_available=True,
)

print(f"✅ Created product: {product.name}")
print(f"   ID: {product.id}")
print(f"   Price: PKR {product.price}")
print(f"   Stock: {product.stock}")
print(f"   Colors: {product.frame_colors}")
print(f"   Sizes: {product.sizes}")
print(f"   Lens Options: {product.lens_options}")

