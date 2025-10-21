from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from authentication.views import get_profile

urlpatterns = [
    # Admin panel removed for now
    # path('admin/', admin.site.urls),
    path('api/auth/', include('authentication.urls')),
    path('api/user/profile', get_profile, name='get_profile'),
    path('api/', include('products.urls')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

