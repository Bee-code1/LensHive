# Django Authentication Models Documentation

**File Path:** `backend/authentication/models.py`

## Purpose
Defines the custom User model and UserManager for email-based authentication in the LensHive backend using Django's authentication system.

## Key Concepts & Components

### 1. **Custom User Model**
```python
class User(AbstractBaseUser, PermissionsMixin)
```
- **AbstractBaseUser**: Base class providing core authentication functionality
- **PermissionsMixin**: Adds permission and group management
- **Why custom**: Default Django user uses username; we need email-based auth

### 2. **UUID as Primary Key**
```python
id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
```
- **What it is**: Universal Unique Identifier (128-bit)
- **Why use it**: Better security, no sequential IDs, works across distributed systems
- **Format**: `550e8400-e29b-41d4-a716-446655440000`
- **Learning**: More secure than auto-increment integers

### 3. **Custom User Manager**
```python
class UserManager(BaseUserManager)
```
- **Purpose**: Handles user creation logic
- **Methods**: `create_user()`, `create_superuser()`
- **Why needed**: Custom user model requires custom manager

## Model Fields

### User Model Fields

| Field | Type | Purpose | Indexed |
|-------|------|---------|---------|
| `id` | UUIDField | Unique identifier | Primary Key |
| `full_name` | CharField(255) | User's full name | No |
| `email` | EmailField(255) | Login email | Yes |
| `is_active` | BooleanField | Account active status | No |
| `is_admin` | BooleanField | Admin privileges | No |
| `is_staff` | BooleanField | Staff access | No |
| `is_superuser` | BooleanField | Superuser status | No |
| `created_at` | DateTimeField | Registration date | No |
| `updated_at` | DateTimeField | Last update | No |

### Field Details

#### Email Field
```python
email = models.EmailField(unique=True, max_length=255, db_index=True)
```
- **unique=True**: No duplicate emails
- **db_index=True**: Faster email lookups
- **Used as USERNAME_FIELD**: Primary authentication field

#### Password Field
- Inherited from `AbstractBaseUser`
- Automatically hashed using PBKDF2 algorithm
- Never stored in plain text

#### Timestamp Fields
```python
created_at = models.DateTimeField(auto_now_add=True)  # Set once on creation
updated_at = models.DateTimeField(auto_now=True)      # Updates on every save
```

## UserManager Methods

### create_user()
```python
def create_user(self, email, full_name, password=None)
```
- **Purpose**: Create regular user
- **Process**:
  1. Validates email and full_name
  2. Normalizes email (lowercases domain)
  3. Hashes password using Django's `set_password()`
  4. Saves to database
- **Returns**: User instance

### create_superuser()
```python
def create_superuser(self, email, full_name, password=None)
```
- **Purpose**: Create admin user
- **Process**:
  1. Calls `create_user()`
  2. Sets admin flags to True
  3. Saves to database
- **Returns**: User instance with admin privileges

## Authentication Configuration

### USERNAME_FIELD
```python
USERNAME_FIELD = 'email'
```
- **What it is**: Field used for authentication
- **Default Django**: Uses 'username'
- **Our choice**: Email for modern auth pattern

### REQUIRED_FIELDS
```python
REQUIRED_FIELDS = ['full_name']
```
- **Purpose**: Additional fields required when creating superuser
- **Note**: USERNAME_FIELD and password are always required

## Permission Methods

### has_perm()
```python
def has_perm(self, perm, obj=None):
    return self.is_admin
```
- **Purpose**: Check if user has specific permission
- **Our implementation**: All admins have all permissions
- **Learning**: Can be customized for fine-grained permissions

### has_module_perms()
```python
def has_module_perms(self, app_label):
    return self.is_admin
```
- **Purpose**: Check if user can access Django admin module
- **Our implementation**: Only admins can access

## Database Configuration

### Meta Class
```python
class Meta:
    db_table = 'users'
    verbose_name = 'User'
    verbose_name_plural = 'Users'
```
- **db_table**: Custom table name instead of default `authentication_user`
- **verbose_name**: Human-readable name for Django admin

## Data Flow

### User Registration
1. Frontend sends: `{fullName, email, password}`
2. Serializer validates data
3. `UserManager.create_user()` called
4. Email normalized and validated
5. Password hashed with `set_password()`
6. User saved to database
7. Token created for authentication
8. User data returned to frontend

### User Login
1. Frontend sends: `{email, password}`
2. Django queries User by email
3. `check_password()` compares hashed passwords
4. If match: return user + token
5. If no match: return error

## Security Features

### Password Hashing
```python
user.set_password(password)  # Hashes before saving
user.check_password(password)  # Compares hashed values
```
- **Algorithm**: PBKDF2 with SHA256
- **Iterations**: 390,000 (Django 4.2+)
- **Learning**: Never store plain-text passwords

### Email Normalization
```python
self.normalize_email(email)
```
- Lowercases the domain part
- Example: `John@EXAMPLE.COM` → `John@example.com`
- **Why**: Prevents duplicate accounts

## Learning Notes

### Why AbstractBaseUser?
- Full control over user model
- Can customize authentication
- Choose any field as username

### Why PermissionsMixin?
- Adds Django's permission system
- Provides `is_superuser`, groups, user_permissions
- Enables Django admin access control

### UUID vs Integer ID
| UUID | Integer |
|------|---------|
| Non-sequential | Sequential (1, 2, 3...) |
| 128-bit | 32 or 64-bit |
| Globally unique | Unique per table |
| Less guessable | Predictable |
| Better for APIs | Simpler |

## Common Issues & Solutions

**Issue**: Can't create superuser
- **Solution**: Ensure `full_name` is provided (it's required)

**Issue**: Email already exists error
- **Solution**: Email must be unique; use different email

**Issue**: Password not saved correctly
- **Solution**: Always use `set_password()`, never assign directly

**Issue**: User can't log in to admin
- **Solution**: Check `is_staff=True` for admin access

## Database Queries

### Create User
```python
user = User.objects.create_user(
    email='john@example.com',
    full_name='John Doe',
    password='securepass123'
)
```

### Get User by Email
```python
user = User.objects.get(email='john@example.com')
```

### Check if Email Exists
```python
exists = User.objects.filter(email='john@example.com').exists()
```

### Update User
```python
user.full_name = 'John Smith'
user.save()
```

## Integration Points

### With Django Rest Framework
- Token authentication uses this User model
- Serializers reference this model
- Permissions check against user fields

### With Frontend
- Frontend receives: `{id, full_name, email, created_at}`
- Frontend stores: `id`, `email`, `full_name`, `token`
- Password never sent to frontend

## Best Practices

1. **Always hash passwords**: Use `set_password()`
2. **Normalize emails**: Use `normalize_email()`
3. **Validate input**: Check email format, password strength
4. **Use UUID**: Better security for public APIs
5. **Index frequently queried fields**: Email has `db_index=True`

## Future Enhancements
- Add email verification field
- Add profile picture field
- Add phone number field
- Add social auth integration
- Add two-factor authentication
- Add user preferences/settings

