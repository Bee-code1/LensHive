from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Product
from .serializers import ProductSerializer

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
