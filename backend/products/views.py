from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Product, ProductImage
from .serializers import ProductSerializer, ProductImageSerializer

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticated]  # Requires authentication to access

    def get_permissions(self):
        """
        Allow unauthenticated access to list and retrieve actions,
        but require authentication for create, update, and delete actions.
        """
        if self.action in ['list', 'retrieve']:
            return []
        return [IsAuthenticated()]

    def create(self, request, *args, **kwargs):
        images = request.FILES.getlist('images', [])
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        product = serializer.save()

        for index, image in enumerate(images):
            ProductImage.objects.create(
                product=product,
                image=image,
                is_primary=(index == 0)  # First image will be primary
            )

        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def update(self, request, *args, **kwargs):
        images = request.FILES.getlist('images', [])
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        product = serializer.save()

        # Handle new images
        for image in images:
            ProductImage.objects.create(
                product=product,
                image=image,
                is_primary=not product.images.exists()  # Make primary if no other images exist
            )

        return Response(serializer.data)

    @action(detail=True, methods=['post'])
    def delete_image(self, request, pk=None):
        product = self.get_object()
        image_id = request.data.get('image_id')
        
        try:
            image = product.images.get(id=image_id)
            was_primary = image.is_primary
            image.delete()
            
            if was_primary:
                # Make the next available image primary
                next_image = product.images.first()
                if next_image:
                    next_image.is_primary = True
                    next_image.save()
                    
            return Response(status=status.HTTP_204_NO_CONTENT)
        except ProductImage.DoesNotExist:
            return Response({'error': 'Image not found'}, status=status.HTTP_404_NOT_FOUND)

    @action(detail=True, methods=['post'])
    def set_primary_image(self, request, pk=None):
        product = self.get_object()
        image_id = request.data.get('image_id')
        
        try:
            image = product.images.get(id=image_id)
            image.is_primary = True
            image.save()  # This will automatically set other images to not primary
            return Response(status=status.HTTP_200_OK)
        except ProductImage.DoesNotExist:
            return Response({'error': 'Image not found'}, status=status.HTTP_404_NOT_FOUND)
