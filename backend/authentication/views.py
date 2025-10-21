from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.authtoken.models import Token
from .serializers import RegisterSerializer, LoginSerializer, UserSerializer
from .models import User

@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    """
    Register a new user
    POST /api/auth/register
    Body: {"fullName": "John Doe", "email": "john@example.com", "password": "password123"}
    OR:   {"full_name": "John Doe", "email": "john@example.com", "password": "password123"}
    """
    # Log incoming data for debugging
    print(f"Received registration data: {request.data}")
    
    serializer = RegisterSerializer(data=request.data)
    
    if serializer.is_valid():
        user = serializer.save()
        # Create authentication token
        token, created = Token.objects.get_or_create(user=user)
        
        # Serialize user data
        user_data = UserSerializer(user).data
        
        return Response({
            'message': 'User registered successfully',
            'user': user_data,
            'token': token.key
        }, status=status.HTTP_201_CREATED)
    
    # Return validation errors
    errors = serializer.errors
    error_message = 'Registration failed'
    
    if 'email' in errors:
        error_message = errors['email'][0]
    elif 'password' in errors:
        error_message = errors['password'][0]
    elif 'full_name' in errors:
        error_message = errors['full_name'][0]
    
    return Response({
        'message': error_message,
        'errors': errors
    }, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    """
    Login user
    POST /api/auth/login
    Body: {"email": "john@example.com", "password": "password123"}
    """
    serializer = LoginSerializer(data=request.data)
    
    if serializer.is_valid():
        user = serializer.validated_data['user']
        # Get or create authentication token
        token, created = Token.objects.get_or_create(user=user)
        
        # Serialize user data
        user_data = UserSerializer(user).data
        
        return Response({
            'message': 'Login successful',
            'user': user_data,
            'token': token.key
        }, status=status.HTTP_200_OK)
    
    # Return error message
    errors = serializer.errors
    error_message = errors.get('non_field_errors', ['Login failed'])[0]
    
    return Response({
        'message': error_message
    }, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_profile(request):
    """
    Get user profile
    GET /api/user/profile
    Headers: Authorization: Token <token>
    """
    user_data = UserSerializer(request.user).data
    return Response({
        'user': user_data
    }, status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout(request):
    """
    Logout user
    POST /api/auth/logout
    Headers: Authorization: Token <token>
    """
    try:
        # Delete the user's authentication token
        request.user.auth_token.delete()
        return Response({
            'message': 'Logout successful'
        }, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({
            'message': 'Logout failed',
            'error': str(e)
        }, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def verify_token(request):
    """
    Verify authentication token
    GET /api/auth/verify
    Headers: Authorization: Token <token>
    """
    # Token is already verified by IsAuthenticated permission
    user_data = UserSerializer(request.user).data
    return Response(user_data, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([AllowAny])
def test_connection(request):
    """Test API connection"""
    return Response({
        'message': 'LensHive API is running!',
        'status': 'success'
    }, status=status.HTTP_200_OK)

