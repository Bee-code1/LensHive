from django.urls import path
from . import views, admin_views

urlpatterns = [
    # Authentication endpoints
    path('register/', views.register, name='register'),
    path('login/', views.login, name='login'),
    path('logout/', views.logout, name='logout'),
    path('verify/', views.verify_token, name='verify_token'),
    path('test/', views.test_connection, name='test_connection'),
    
    # Admin user management endpoints
    path('users/', admin_views.list_users, name='list_users'),
    path('users/create/', admin_views.create_user, name='create_user'),
    path('users/<uuid:user_id>/', admin_views.manage_user, name='manage_user'),
]

