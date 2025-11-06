from django.db import models
from django.core.validators import MinValueValidator

class Product(models.Model):
    CATEGORY_CHOICES = [
        ('Men', 'Men'),
        ('Women', 'Women'),
        ('Kids', 'Kids'),
        ('Unisex', 'Unisex'),
    ]
    
    name = models.CharField(max_length=200)
    description = models.TextField()
    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(0)]
    )
    stock = models.IntegerField(
        default=0,
        validators=[MinValueValidator(0)]
    )
    category = models.CharField(
        max_length=50,
        choices=CATEGORY_CHOICES,
        null=True,
        blank=True
    )
    brand = models.CharField(max_length=100, null=True, blank=True)
    
    # Frame colors - stored as comma-separated values (e.g., "Obsidian,Silver,Gray,Rose")
    frame_colors = models.TextField(
        null=True,
        blank=True,
        help_text="Comma-separated list of frame colors"
    )
    
    # Sizes - stored as comma-separated values (e.g., "Small,Medium,Large")
    sizes = models.CharField(
        max_length=200,
        null=True,
        blank=True,
        help_text="Comma-separated list of sizes (e.g., Small,Medium,Large)"
    )
    
    # Lens options - stored as comma-separated values (e.g., "Frame only,Customize Lenses")
    lens_options = models.TextField(
        null=True,
        blank=True,
        help_text="Comma-separated list of lens options"
    )
    
    # Rating and review information
    rating = models.DecimalField(
        max_digits=3,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(0)]
    )
    review_count = models.IntegerField(default=0)
    
    # Product badges
    is_bestseller = models.BooleanField(default=False)
    is_new = models.BooleanField(default=False)
    is_available = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return self.name
    
    @property
    def frame_colors_list(self):
        """Return frame colors as a list"""
        if self.frame_colors:
            return [color.strip() for color in self.frame_colors.split(',')]
        return []
    
    @property
    def sizes_list(self):
        """Return sizes as a list"""
        if self.sizes:
            return [size.strip() for size in self.sizes.split(',')]
        return []
    
    @property
    def lens_options_list(self):
        """Return lens options as a list"""
        if self.lens_options:
            return [option.strip() for option in self.lens_options.split(',')]
        return []

class ProductImage(models.Model):
    product = models.ForeignKey(Product, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(upload_to='products/')
    is_primary = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-is_primary', '-created_at']

    def save(self, *args, **kwargs):
        if self.is_primary:
            # Set all other images of this product to not primary
            ProductImage.objects.filter(product=self.product).update(is_primary=False)
        elif not ProductImage.objects.filter(product=self.product).exists():
            # If this is the first image, make it primary
            self.is_primary = True
        super().save(*args, **kwargs)
