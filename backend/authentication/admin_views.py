from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import User
from .serializers import UserSerializer, AdminUserSerializer
from .permissions import IsAdminUser

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsAdminUser])
def list_users(request):
    """
    List all users (admin only)
    GET /api/auth/users/
    """
    try:
        users = User.objects.all().order_by('-created_at')
        serializer = AdminUserSerializer(users, many=True)
        return Response(serializer.data)
    except Exception as e:
        return Response(
            {'message': str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['POST'])
@permission_classes([IsAuthenticated, IsAdminUser])
def create_user(request):
    """
    Create a new user (admin only)
    POST /api/auth/users/create/
    """
    try:
        serializer = AdminUserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            # Return the created user data without the password
            return Response(
                AdminUserSerializer(user).data,
                status=status.HTTP_201_CREATED
            )
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response(
            {'message': str(e)},
            status=status.HTTP_400_BAD_REQUEST
        )

@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes([IsAuthenticated, IsAdminUser])
def manage_user(request, user_id):
    """
    Manage a specific user (admin only)
    GET/PUT/DELETE /api/auth/users/{user_id}/
    """
    try:
        # Convert string UUID if needed
        from uuid import UUID
        if isinstance(user_id, str):
            user_id = UUID(user_id)
        
        user = User.objects.get(id=user_id)
    except (User.DoesNotExist, ValueError, TypeError):
        return Response(
            {'message': 'User not found or invalid ID format'}, 
            status=status.HTTP_404_NOT_FOUND
        )

    if request.method == 'GET':
        serializer = AdminUserSerializer(user)
        return Response(serializer.data)

    elif request.method == 'PUT':
        print(f"Updating user {user_id}, received data:", request.data)  # Debug log
        serializer = AdminUserSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            # Prevent removing admin role from yourself
            if request.user == user and request.data.get('role') != 'admin':
                return Response(
                    {'message': 'Cannot remove admin role from yourself'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            try:
                updated_user = serializer.save()
                print(f"User {user_id} updated successfully")  # Debug log
                return Response(AdminUserSerializer(updated_user).data)
            except Exception as e:
                print(f"Error updating user {user_id}:", str(e))  # Debug log
                return Response(
                    {'message': f'Error updating user: {str(e)}'},
                    status=status.HTTP_400_BAD_REQUEST
                )
        print(f"Validation errors for user {user_id}:", serializer.errors)  # Debug log
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        # Prevent self-deletion
        if user == request.user:
            return Response(
                {'message': 'Cannot delete your own account'}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)