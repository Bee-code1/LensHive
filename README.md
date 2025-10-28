# 🎯 LensHive

A modern camera rental platform built with Flutter (Frontend) and Django (Backend) with MySQL database.

## 📱 Features

- ✅ User Registration & Authentication
- ✅ Email-based Login System
- ✅ Token-based API Security
- ✅ MySQL Database Integration
- ✅ Cross-platform Support (Web, Android, iOS)
- ✅ RESTful API Architecture

---

## 🏗️ Project Structure

```
LENSHIVE/
├── lenshive/          # Flutter Frontend Application
│   ├── lib/
│   │   ├── models/    # Data models
│   │   ├── screens/   # UI screens
│   │   ├── services/  # API services
│   │   └── main.dart
│   └── pubspec.yaml
│
└── backend/           # Django Backend API
    ├── authentication/    # Authentication app
    ├── lenshive_backend/  # Main Django project
    ├── manage.py
    └── requirements.txt
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- Flutter SDK
- MySQL (via XAMPP)
- Git

---

## 🔧 Backend Setup

### 1. Navigate to backend folder
```bash
cd backend
```

### 2. Create and activate virtual environment
```bash
python -m venv venv
venv\Scripts\Activate.ps1  # Windows PowerShell
```

### 3. Install dependencies
```bash
pip install -r requirements.txt
```

### 4. Configure database
- Start XAMPP MySQL
- Create database: `lenshive_db`
- Update `.env` file with your database credentials

### 5. Run migrations
```bash
python manage.py makemigrations
python manage.py migrate
```

### 6. Start Django server
```bash
python manage.py runserver 8000
```

Backend will be running at: `http://localhost:8000`

---

## 📱 Frontend Setup

### 1. Navigate to Flutter app folder
```bash
cd lenshive
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run the app
```bash
# For Chrome/Web
flutter run -d chrome

# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

---

## 🌐 API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/auth/test` | Test API connection | No |
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| POST | `/api/auth/logout` | Logout user | Yes |
| GET | `/api/user/profile` | Get user profile | Yes |

### Registration Example

**Request:**
```json
POST /api/auth/register
{
  "fullName": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": "uuid-here",
    "full_name": "John Doe",
    "email": "john@example.com",
    "created_at": "2024-10-20T12:30:45Z"
  },
  "token": "auth-token-here"
}
```

---

## 🔐 Environment Variables

Create a `.env` file in the `backend/` directory:

```env
SECRET_KEY=your-secret-key-here
DEBUG=True
DB_NAME=lenshive_db
DB_USER=root
DB_PASSWORD=
DB_HOST=localhost
DB_PORT=3306
```

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** - UI Framework
- **Dart** - Programming Language
- **HTTP** - API Communication

### Backend
- **Django** - Python Web Framework
- **Django REST Framework** - RESTful API
- **MySQL** - Database
- **PyMySQL** - MySQL Driver
- **Token Authentication** - Security

---

## 📊 Database Schema

### Users Table
| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary Key |
| full_name | VARCHAR(255) | User's full name |
| email | VARCHAR(255) | Unique email |
| password | VARCHAR(128) | Hashed password |
| is_active | BOOLEAN | Account status |
| created_at | DATETIME | Registration timestamp |
| updated_at | DATETIME | Last update timestamp |

---

## 🧪 Testing

### Test API with curl
```bash
# Test connection
curl http://localhost:8000/api/auth/test

# Register user
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Test User","email":"test@example.com","password":"test123456"}'
```

### Test API with Postman
1. Import the endpoints from the API documentation
2. Test registration, login, and profile retrieval
3. Verify token authentication

---

## 📝 Development Notes

### For Web Development (Chrome)
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

### For Android Emulator
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

### For Real Device (Same WiFi)
```dart
static const String baseUrl = 'http://YOUR_PC_IP:8000/api';
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@Bee-code1](https://github.com/Bee-code1)
- Repository: [LensHive](https://github.com/Bee-code1/LensHive)

---

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- Django Team for the robust backend framework
- All contributors and supporters

---

## 📞 Support

For support, email your-email@example.com or create an issue in the repository.

---

**Made with ❤️ for LensHive FYP Project**


