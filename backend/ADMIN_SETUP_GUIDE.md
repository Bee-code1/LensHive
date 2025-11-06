# LensHive Admin Setup Guide

## Overview
LensHive uses a **simplified role-based authentication system** without Django's built-in admin panel. Users are managed through a custom React admin dashboard.

---

## User Roles

The system has three roles:

| Role | Description | Permissions |
|------|-------------|-------------|
| **customer** | Regular app users | - Use the mobile app<br>- Take quizzes<br>- Browse products |
| **staff** | Staff members | - Manage products<br>- View analytics<br>- Access admin dashboard |
| **admin** | Administrators | - All staff permissions<br>- Manage users<br>- Full system access |

**Default role for new users:** `customer`

---

## Creating Admin Users

### Method 1: Create New Admin (Recommended)

Use the `createadmin` management command:

```bash
# Interactive mode (prompts for details)
python manage.py createadmin


# Or provide arguments directly
python manage.py createadmin --email admin@lenshive.com --name "John Doe" --password "SecurePass123"
```

**Example:**
```bash
$ python manage.py createadmin
Email address: admin@lenshive.com
Full name: John Doe
Password: 
Password (again): 
Successfully created admin user: admin@lenshive.com
```

---

### Method 2: Promote Existing User to Admin

If a user already exists and you want to make them admin:

```bash
python manage.py set_admin_role user@example.com
```

**Example:**
```bash
$ python manage.py set_admin_role john@example.com
Successfully changed role to admin for: john@example.com
```

---

## Database Migration

After updating the User model, run migrations:

```bash
# Apply the new schema changes
python manage.py migrate

# This will:
# - Add 'customer' role option
# - Remove is_superuser, is_admin, is_staff columns
# - Keep only the 'role' field for permissions
```

---

## Accessing the Admin Dashboard

1. **Start the backend server:**
   ```bash
   cd backend
   python manage.py runserver
   ```

2. **Start the admin dashboard:**
   ```bash
   cd admin-dashboard
   npm run dev
   ```

3. **Login with admin credentials:**
   - URL: `http://localhost:5173` (or your Vite dev server URL)
   - Use the email and password of an admin user

---

## Custom Admin Dashboard Features

Your LensHive admin dashboard is a **React-based custom interface** built with Material-UI (MUI). Here's what it can do:

### 📊 **Dashboard Page** (`/dashboard`)

**Overview & Analytics:**
- **Statistics Cards:**
  - Total Products (live from API)
  - Total Orders (mock data - ready for implementation)
  - Total Users (mock data)
  - Revenue (mock data)

- **Charts & Visualizations:**
  - Sales Overview (Line Chart) - Shows monthly sales trends
  - Product Categories (Pie Chart) - Distribution of product categories
  - Recent Products Table - Last 5 added products
  - Recent Orders Table - Latest order statuses

**Technologies Used:**
- Recharts for data visualization
- Material-UI for UI components
- Real-time data fetching from Django API

---

### 👥 **Users Management** (`/users`)

**Features:**
- **View All Users:**
  - Paginated data table with sorting
  - Quick search/filter functionality
  - View name, email, role, and status

- **Create New User:**
  - Full name input
  - Email validation
  - Password (required for new users)
  - Role selection: Staff or Admin
  - Status: Active/Inactive

- **Edit Existing User:**
  - Update user information
  - Change role
  - Toggle active status
  - Optional password update (leave blank to keep current)

- **Delete User:**
  - Confirmation dialog
  - Cannot delete yourself
  - Cannot remove admin role from yourself

**Permissions:**
- ✅ **Admin role required** - Only `role='admin'` can access
- ❌ Staff members cannot manage users

**Role Display:**
- Color-coded badges (Admin = blue, Staff = gray)
- Active/Inactive status indicators

---

### 📦 **Products Management** (`/products`)

**Features:**
- **View All Products:**
  - Data grid with image thumbnails
  - Product name, description, price, stock
  - Quick search and filter
  - Sortable columns

- **Add New Product:**
  - Product name
  - Description (multiline)
  - Price (numeric validation)
  - Stock quantity
  - Multiple image upload

- **Edit Product:**
  - Update all product details
  - Manage existing images:
    - Delete images (with confirmation)
    - Set primary image (star icon)
  - Add new images
  - Image preview before saving

- **Delete Product:**
  - Confirmation dialog
  - Removes product and all associated images

**Image Management:**
- Upload multiple images at once
- Preview images before uploading
- Set primary image for product display
- Delete individual images
- View existing images with thumbnails

**Permissions:**
- ✅ **Staff and Admin** - Both can manage products
- Full CRUD operations available

---

### 🔐 **Login Page** (`/login`)

**Features:**
- Email-based authentication
- Password input with visibility toggle
- Token-based authentication
- Redirects to dashboard on success
- Error handling and validation
- Remember authentication state

**Security:**
- Token stored in localStorage
- Authorization header auto-attached
- Protected routes check authentication

---

### 🎨 **UI/UX Features**

**Material-UI Components:**
- Responsive grid layout
- Modern card-based design
- Data tables with MUI DataGrid
- Modal dialogs for forms
- Icon buttons for actions
- Snackbar notifications

**User Experience:**
- Real-time notifications (success/error)
- Loading states
- Form validation
- Confirmation dialogs for destructive actions
- Responsive design (works on mobile/tablet)
- Quick search and filters
- Bulk selection capabilities

**Navigation:**
- Sidebar navigation menu
- Active page highlighting
- User profile display
- Logout functionality
- Role-based menu items

---

### 🔧 **Technical Stack**

**Frontend:**
- React 18.2.0
- React Router DOM 6.19.0
- Material-UI 5.14.18
- Recharts 2.9.3 (for charts)
- Axios 1.6.2 (API calls)
- Vite 4.5.0 (build tool)

**State Management:**
- Redux Toolkit 1.9.7
- React Context API (AuthContext)
- Custom hooks (usePermissions)

**Key Features:**
- Token-based authentication
- Role-based access control
- Real-time API integration
- Image upload and management
- Data visualization
- Responsive design

---

### 📱 **Pages Structure**

```
admin-dashboard/
├── src/
│   ├── pages/
│   │   ├── Dashboard.jsx      → Analytics & Overview
│   │   ├── Users.jsx          → User Management (Admin only)
│   │   ├── Products.jsx       → Product Management
│   │   └── Login.jsx          → Authentication
│   ├── components/
│   │   ├── Layout.jsx         → Main layout with sidebar
│   │   └── auth/
│   │       └── ProtectedRoute.jsx → Route protection
│   ├── context/
│   │   └── AuthContext.jsx    → Authentication state
│   ├── hooks/
│   │   └── usePermissions.js  → Permission checking
│   └── main.jsx               → App entry point
```

---

### 🚀 **Getting Started with Admin Dashboard**

1. **Install Dependencies:**
   ```bash
   cd admin-dashboard
   npm install
   ```

2. **Start Development Server:**
   ```bash
   npm run dev
   ```

3. **Access Dashboard:**
   - URL: `http://localhost:5173`
   - Login with admin credentials

4. **Build for Production:**
   ```bash
   npm run build
   npm run preview
   ```

---

### 🆚 **Custom Dashboard vs Django Admin**

| Feature | Django Built-in Admin | LensHive Custom Dashboard |
|---------|----------------------|---------------------------|
| **Technology** | Django templates | React + Material-UI |
| **Design** | Generic admin interface | Custom branded design |
| **Customization** | Limited, Django-specific | Full React control |
| **User Management** | ✅ Full CRUD | ✅ Full CRUD (Admin only) |
| **Product Management** | ✅ If registered | ✅ With image management |
| **Analytics** | ❌ Not built-in | ✅ Charts & visualizations |
| **Mobile Friendly** | ❌ Not optimized | ✅ Responsive design |
| **API Integration** | Direct DB access | REST API integration |
| **Authentication** | Django sessions | Token-based |
| **Role Control** | Complex permissions | Simple role-based |
| **Learning Curve** | Django knowledge needed | React knowledge |
| **Extensibility** | Django plugins | React components |

---

### 💡 **Why Custom Dashboard?**

**Advantages:**
1. **Full Control** - Design matches your brand
2. **Modern UX** - React-based SPA experience
3. **Mobile Ready** - Responsive Material-UI components
4. **Easy to Extend** - Add new features with React components
5. **API First** - Works with your REST API
6. **Better Analytics** - Custom charts and visualizations
7. **Role Clarity** - Simple `customer`, `staff`, `admin` roles
8. **Developer Friendly** - Use React skills you already have

**What You Get:**
- Professional admin interface
- User management (admin only)
- Product & image management
- Dashboard with analytics
- Real-time notifications
- Responsive design
- Easy to customize

---

## API Endpoints for User Management

Admin users can access these endpoints:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/users/` | GET | List all users |
| `/api/auth/users/create/` | POST | Create new user |
| `/api/auth/users/{id}/` | GET | Get user details |
| `/api/auth/users/{id}/` | PUT | Update user |
| `/api/auth/users/{id}/` | DELETE | Delete user |

**Authentication required:** Token-based auth with `role='admin'`

---

## Permission System

### How It Works

The system uses a custom `IsAdminUser` permission class that checks the user's `role` field:

```python
class IsAdminUser(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.role == 'admin'
```

### Role-Based Permissions

```python
# Permissions returned in user serializer
{
    'can_manage_users': user.role == 'admin',           # Admin only
    'can_manage_products': user.role in ['admin', 'staff'],  # Admin & Staff
    'can_view_analytics': user.role in ['admin', 'staff'],   # Admin & Staff
}
```

---

## Important Changes from Django Admin

### What Was Removed
- ❌ Django built-in admin panel (`/admin/`)
- ❌ `is_superuser` field
- ❌ `is_admin` field
- ❌ `is_staff` field
- ❌ `create_superuser` command

### What Was Added
- ✅ Single `role` field with 3 choices: `customer`, `staff`, `admin`
- ✅ Custom React admin dashboard
- ✅ `createadmin` management command
- ✅ `set_admin_role` management command
- ✅ Simplified permission system

---

## Troubleshooting

### "Cannot login to admin dashboard"
- Verify user has `role='admin'` (not just `role='staff'`)
- Check that the user is active: `is_active=True`
- Verify the token is valid

### "Permission denied on API endpoint"
- Ensure you're sending the token in headers: `Authorization: Token <your-token>`
- Check that the endpoint requires admin role
- Verify user role in database

### "Command not found: createadmin"
- Make sure you're in the `backend` directory
- Verify the virtual environment is activated
- Check that the command file exists: `authentication/management/commands/createadmin.py`

### Checking User Role in Database

```bash
# Using Django shell
python manage.py shell

from authentication.models import User
user = User.objects.get(email='admin@lenshive.com')
print(f"Role: {user.role}")
print(f"Is Active: {user.is_active}")
```

---

## Security Best Practices

1. **Strong Passwords:** Use complex passwords for admin accounts
2. **Limit Admin Users:** Only create admin accounts when necessary
3. **Use Staff Role:** Give staff members `role='staff'` instead of `admin` when possible
4. **Regular Audits:** Periodically review user roles and remove unused accounts
5. **Production Security:** 
   - Set `DEBUG=False` in production
   - Use environment variables for secrets
   - Enable HTTPS
   - Restrict CORS to specific domains

---

## Quick Reference

```bash
# Create first admin user
python manage.py createadmin

# Promote existing user to admin
python manage.py set_admin_role user@example.com

# Apply database changes
python manage.py migrate

# Start backend
python manage.py runserver

# Start admin dashboard (in separate terminal)
cd admin-dashboard && npm run dev
```

---

## Need Help?

- Check the models: `backend/authentication/models.py`
- Check permissions: `backend/authentication/permissions.py`
- Check API views: `backend/authentication/admin_views.py`
- Review frontend: `admin-dashboard/src/`

