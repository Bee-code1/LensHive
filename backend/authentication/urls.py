from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register, name='register'),
    path('login/', views.login, name='login'),
    path('logout/', views.logout, name='logout'),
    path('verify/', views.verify_token, name='verify_token'),
    path('test/', views.test_connection, name='test_connection'),
]

