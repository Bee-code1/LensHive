# LensHive Admin - Quick Reference Card

## 🚀 Create Your First Admin

```bash
cd backend
python manage.py createadmin
```

Enter:
- Email: `admin@lenshive.com`
- Name: `Admin User`
- Password: `YourSecurePassword123`

---

## 📋 User Roles

| Role | Can Do |
|------|--------|
| **customer** | Use mobile app, take quizzes, browse products |
| **staff** | Manage products, view analytics, access dashboard |
| **admin** | Everything + manage users |

---

## 🔧 Common Commands

```bash
# Create new admin
python manage.py createadmin

# Make existing user admin
python manage.py set_admin_role user@example.com

# Apply database changes
python manage.py migrate

# Start backend server
python manage.py runserver

# Start admin dashboard
cd admin-dashboard && npm run dev
```

---

## 🌐 Admin Dashboard Access

1. **URL:** `http://localhost:5173`
2. **Login:** Use admin email & password
3. **Requirements:** 
   - Backend running on port 8000
   - User must have `role='admin'`

---

## 🔑 API Authentication

**Headers:**
```
Authorization: Token YOUR_TOKEN_HERE
Content-Type: application/json
```

**Get Token:**
```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lenshive.com","password":"YourPassword"}'
```

---

## 📊 Admin API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/users/` | GET | List all users |
| `/api/auth/users/create/` | POST | Create user |
| `/api/auth/users/{id}/` | GET | Get user details |
| `/api/auth/users/{id}/` | PUT | Update user |
| `/api/auth/users/{id}/` | DELETE | Delete user |

**Permission Required:** `role='admin'`

---

## ⚠️ Important Notes

- ❌ No more Django admin panel
- ❌ No more `createsuperuser` command
- ❌ No more `is_superuser`, `is_admin`, `is_staff` fields
- ✅ Use `role` field: `customer`, `staff`, or `admin`
- ✅ Use custom React admin dashboard
- ✅ Use `createadmin` command

---

## 🐛 Troubleshooting

**Can't login to dashboard?**
- Check user has `role='admin'`
- Check user `is_active=True`
- Verify backend is running

**Permission denied?**
- Check Authorization header has token
- Verify user role is 'admin'
- Check endpoint requires admin role

**Command not found?**
- Activate virtual environment
- Check you're in backend directory
- Verify command file exists

---

## 📚 More Help

- Full Guide: `ADMIN_SETUP_GUIDE.md`
- Changes: `CHANGES_SUMMARY.md`
- Models: `authentication/models.py`
- Permissions: `authentication/permissions.py`

