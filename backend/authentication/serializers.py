from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model"""
    
    class Meta:
        model = User
        fields = ['id', 'full_name', 'email', 'role', 'is_active', 'created_at']
        read_only_fields = ['id', 'created_at']

    def to_representation(self, instance):
        data = super().to_representation(instance)
        # Add permissions based on role
        data['permissions'] = {
            'can_manage_users': instance.role == 'admin',
            'can_manage_products': instance.role in ['admin', 'staff'],
            'can_view_analytics': instance.role in ['admin', 'staff'],
        }
        return data

class RegisterSerializer(serializers.ModelSerializer):
    """Serializer for user registration"""
    
    # Accept both camelCase (Flutter) and snake_case (Django)
    fullName = serializers.CharField(
        source='full_name',
        max_length=255,
        required=False,
        allow_blank=True
    )
    full_name = serializers.CharField(
        max_length=255,
        required=False,
        allow_blank=True
    )
    
    password = serializers.CharField(
        write_only=True,
        min_length=6,
        style={'input_type': 'password'}
    )
    
    class Meta:
        model = User
        fields = ['full_name', 'fullName', 'email', 'password']
    
    def validate(self, data):
        """Ensure either full_name or fullName is provided"""
        full_name = data.get('full_name') or data.get('fullName')
        if not full_name or full_name.strip() == '':
            raise serializers.ValidationError({'full_name': 'This field is required.'})
        
        # Set full_name from either field
        data['full_name'] = full_name
        return data
    
    def validate_email(self, value):
        """Check if email already exists"""
        if User.objects.filter(email=value.lower()).exists():
            raise serializers.ValidationError('Email already registered')
        return value.lower()
    
    def create(self, validated_data):
        """Create new user with encrypted password"""
        # Remove fullName if present (we use full_name)
        validated_data.pop('fullName', None)
        
        user = User.objects.create_user(
            email=validated_data['email'],
            full_name=validated_data['full_name'],
            password=validated_data['password']
        )
        return user

class LoginSerializer(serializers.Serializer):
    """Serializer for user login"""
    
    email = serializers.EmailField()
    password = serializers.CharField(
        write_only=True,
        style={'input_type': 'password'}
    )
    
    def validate(self, data):
        """Validate login credentials"""
        email = data.get('email', '').lower()
        password = data.get('password')
        
        if email and password:
            try:
                user = User.objects.get(email=email)
                if user.check_password(password):
                    if not user.is_active:
                        raise serializers.ValidationError('User account is disabled')
                    data['user'] = user
                    return data
                else:
                    raise serializers.ValidationError('Invalid email or password')
            except User.DoesNotExist:
                raise serializers.ValidationError('Invalid email or password')
        else:
            raise serializers.ValidationError('Must include email and password')

