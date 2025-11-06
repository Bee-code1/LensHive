from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
import uuid

class UserManager(BaseUserManager):
    """Custom user manager for email-based authentication"""
    
    def create_user(self, email, full_name, password=None, role='customer', **extra_fields):
        """Create and save a regular user"""
        if not email:
            raise ValueError('Users must have an email address')
        if not full_name:
            raise ValueError('Users must have a full name')
        
        # Set role in extra_fields
        extra_fields.setdefault('role', role)
        
        user = self.model(
            email=self.normalize_email(email),
            full_name=full_name,
            **extra_fields
        )
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_admin(self, email, full_name, password=None):
        """Create and save an admin user"""
        user = self.create_user(
            email=email,
            full_name=full_name,
            password=password,
            role='admin'
        )
        return user

class User(AbstractBaseUser):
    """Custom User model with email as username and role-based access"""
    
    ROLE_CHOICES = [
        ('customer', 'Customer'),
        ('staff', 'Staff'),
        ('admin', 'Admin'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    full_name = models.CharField(max_length=255)
    email = models.EmailField(unique=True, max_length=255, db_index=True)
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='customer')
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    objects = UserManager()
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['full_name']
    
    def __str__(self):
        return self.email
    
    @property
    def is_staff_member(self):
        """Check if user is staff or admin"""
        return self.role in ['staff', 'admin']
    
    @property
    def is_admin_user(self):
        """Check if user is admin"""
        return self.role == 'admin'
    
    class Meta:
        db_table = 'users'
        verbose_name = 'User'
        verbose_name_plural = 'Users'

