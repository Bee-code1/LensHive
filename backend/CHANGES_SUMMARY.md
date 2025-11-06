# LensHive Authentication System Changes

## Summary
Removed Django's built-in admin panel and superuser system. Simplified to a role-based authentication using only the `role` field.

---

## Files Modified

### 1. `lenshive_backend/settings.py`
**Change:** Removed `django.contrib.admin` from `INSTALLED_APPS`

**Before:**
```python
INSTALLED_APPS = [
    'django.contrib.admin',  # ← REMOVED
    'django.contrib.auth',
    ...
]
```

**After:**
```python
INSTALLED_APPS = [
    # Django core apps (admin removed - using custom admin dashboard)
    'django.contrib.auth',
    'django.contrib.contenttypes',
    ...
]
```

---

### 2. `authentication/models.py`
**Changes:**
- Removed `PermissionsMixin` inheritance
- Removed `is_superuser`, `is_admin`, `is_staff` fields
- Added `customer` role to `ROLE_CHOICES`
- Changed default role from `staff` to `customer`
- Removed `create_superuser()` method
- Added `create_admin()` method
- Added `is_staff_member` and `is_admin_user` properties
- Removed `has_perm()` and `has_module_perms()` methods

**Before:**
```python
class User(AbstractBaseUser, PermissionsMixin):
    ROLE_CHOICES = [
        ('admin', 'Admin'),
        ('staff', 'Staff'),
    ]
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='staff')
    is_admin = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
```

**After:**
```python
class User(AbstractBaseUser):
    ROLE_CHOICES = [
        ('customer', 'Customer'),
        ('staff', 'Staff'),
        ('admin', 'Admin'),
    ]
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='customer')
    # Only role field - no is_admin, is_staff, is_superuser
```

---

### 3. `authentication/serializers.py`
**Changes:**
- Simplified `AdminUserSerializer.create()` - removed is_staff and is_admin logic
- Simplified `AdminUserSerializer.update()` - removed role-based flag updates

**Before:**
```python
def create(self, validated_data):
    # ... 
    is_staff = validated_data.get('role') in ['admin', 'staff']
    is_admin = validated_data.get('role') == 'admin'
    user = User.objects.create_user(
        ...,
        is_staff=is_staff,
        is_admin=is_admin,
    )
```

**After:**
```python
def create(self, validated_data):
    user = User.objects.create_user(
        email=validated_data['email'].lower(),
        full_name=validated_data['full_name'],
        password=password,
        role=validated_data.get('role', 'customer'),
        is_active=validated_data.get('is_active', True)
    )
```

---

### 4. `authentication/permissions.py`
**No changes needed** - Already using `role` field correctly:
```python
def has_permission(self, request, view):
    return request.user and request.user.role == 'admin'
```

---

## Files Created

### 1. `authentication/management/commands/createadmin.py`
**Purpose:** Create new admin users

**Usage:**
```bash
python manage.py createadmin
python manage.py createadmin --email admin@test.com --name "Admin" --password "pass123"
```

---

### 2. `authentication/migrations/0003_simplify_user_model.py`
**Purpose:** Database migration to:
- Add 'customer' to role choices
- Remove is_superuser column
- Remove is_admin column
- Remove is_staff column

**Run with:**
```bash
python manage.py migrate
```

---

### 3. `backend/ADMIN_SETUP_GUIDE.md`
**Purpose:** Complete guide for creating and managing admin users

---

### 4. `backend/CHANGES_SUMMARY.md`
**Purpose:** This file - summary of all changes

---

## Files Updated (Minor Changes)

### 1. `authentication/management/commands/set_admin_role.py`
**Change:** Removed is_staff and is_admin assignments (no longer needed)

**Before:**
```python
user.role = 'admin'
user.is_staff = True
user.is_admin = True
user.save()
```

**After:**
```python
user.role = 'admin'
user.save()
```

---

## Migration Path

### For Existing Databases:

1. **Backup your database first!**
   ```bash
   mysqldump -u root -p lenshive_db > backup.sql
   ```

2. **Run the migration:**
   ```bash
   python manage.py migrate
   ```

3. **Update existing users:**
   - Users with `is_admin=True` or `is_superuser=True` should be set to `role='admin'`
   - Users with `is_staff=True` should be set to `role='staff'`
   - All other users should be `role='customer'`

   ```bash
   python manage.py shell
   
   from authentication.models import User
   
   # Set all users to customer by default
   User.objects.filter(role='staff').update(role='customer')
   
   # Manually set admin users (example)
   admin_user = User.objects.get(email='admin@lenshive.com')
   admin_user.role = 'admin'
   admin_user.save()
   ```

4. **Create new admin if needed:**
   ```bash
   python manage.py createadmin
   ```

---

## Testing the Changes

### 1. Test Admin Creation
```bash
python manage.py createadmin --email test@admin.com --name "Test Admin" --password "test123"
```

### 2. Test API Access
```bash
# Login
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"test@admin.com","password":"test123"}'

# Get token from response, then test admin endpoint
curl -X GET http://localhost:8000/api/auth/users/ \
  -H "Authorization: Token YOUR_TOKEN_HERE"
```

### 3. Test Admin Dashboard
1. Start backend: `python manage.py runserver`
2. Start frontend: `cd admin-dashboard && npm run dev`
3. Login with admin credentials
4. Verify you can see users list and manage them

---

## Rollback Plan

If you need to rollback these changes:

1. **Restore database backup:**
   ```bash
   mysql -u root -p lenshive_db < backup.sql
   ```

2. **Revert code changes:**
   ```bash
   git checkout HEAD~1 backend/
   ```

3. **Run old migrations:**
   ```bash
   python manage.py migrate authentication 0002
   ```

---

## Benefits of New System

✅ **Simpler:** One `role` field instead of three boolean flags  
✅ **Clearer:** Easy to understand who can do what  
✅ **Safer:** No confusion between different admin flags  
✅ **Flexible:** Easy to add new roles (e.g., 'moderator', 'vendor')  
✅ **Maintainable:** Less code to maintain  
✅ **Scalable:** Custom admin dashboard can grow with your needs  

---

## Breaking Changes

⚠️ **These will break after migration:**

1. Code checking `user.is_superuser` → Use `user.role == 'admin'`
2. Code checking `user.is_admin` → Use `user.role == 'admin'`
3. Code checking `user.is_staff` → Use `user.role in ['staff', 'admin']`
4. Django admin URL `/admin/` → Use custom dashboard
5. `python manage.py createsuperuser` → Use `python manage.py createadmin`

---

## Questions?

- Check `ADMIN_SETUP_GUIDE.md` for detailed usage instructions
- Review `authentication/models.py` for the new User model
- Test in development before deploying to production

