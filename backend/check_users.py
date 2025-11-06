import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'lenshive_backend.settings')
django.setup()

from authentication.models import User

print("\n=== Checking Users ===\n")
users = User.objects.all()

if not users:
    print("❌ No users found in database!")
    print("\nYou need to run: python manage.py createadmin")
else:
    for user in users:
        print(f"Email: {user.email}")
        print(f"Role: {getattr(user, 'role', 'NO ROLE FIELD')}")
        print(f"Active: {user.is_active}")
        
        # Check if old fields exist
        if hasattr(user, 'is_admin'):
            print(f"❌ OLD FIELD STILL EXISTS: is_admin = {user.is_admin}")
        if hasattr(user, 'is_staff'):
            print(f"❌ OLD FIELD STILL EXISTS: is_staff = {user.is_staff}")
        if hasattr(user, 'is_superuser'):
            print(f"❌ OLD FIELD STILL EXISTS: is_superuser = {user.is_superuser}")
        
        print("-" * 50)

print("\n=== Migration Status ===\n")
from django.db import connection
with connection.cursor() as cursor:
    cursor.execute("DESCRIBE users")
    columns = cursor.fetchall()
    column_names = [col[0] for col in columns]
    
    print("Current columns in users table:")
    for col in column_names:
        print(f"  - {col}")
    
    print("\n")
    if 'is_admin' in column_names:
        print("❌ Migration NOT applied! Old columns still exist.")
        print("   Run: python manage.py migrate")
    else:
        print("✅ Migration applied! Old columns removed.")
        
    if 'role' not in column_names:
        print("❌ Role column missing!")
    else:
        print("✅ Role column exists.")

