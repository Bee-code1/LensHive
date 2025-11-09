from rest_framework import serializers
from .models import Product, ProductImage

class ProductImageSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = ProductImage
        fields = ['id', 'image', 'image_url', 'is_primary', 'created_at']

    def get_image_url(self, obj):
        if obj.image:
            return obj.image.url
        return None

class ProductSerializer(serializers.ModelSerializer):
    images = ProductImageSerializer(many=True, read_only=True)
    primary_image = serializers.SerializerMethodField()
    colors = serializers.SerializerMethodField()
    sizes = serializers.SerializerMethodField()
    lens_options = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = [
            'id', 
            'name', 
            'description', 
            'price',
            'currency',
            'stock', 
            'category',
            'brand',
            'frame_colors',
            'colors',
            'sizes', 
            'lens_options',
            'rating',
            'review_count',
            'is_bestseller',
            'is_new',
            'is_available',
            'images', 
            'primary_image', 
            'created_at', 
            'updated_at'
        ]

    def get_primary_image(self, obj):
        primary_image = obj.images.filter(is_primary=True).first()
        if primary_image:
            return primary_image.image.url
        return None
    
    def get_colors(self, obj):
        """Return frame colors as a list"""
        return obj.frame_colors_list
    
    def get_sizes(self, obj):
        """Return sizes as a list"""
        return obj.sizes_list
    
    def get_lens_options(self, obj):
        """Return lens options as a list"""
        return obj.lens_options_list