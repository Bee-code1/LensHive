import requests
import json

print("\n=== Testing Login API ===\n")

# Test login
url = "http://localhost:8000/api/auth/login/"
data = {
    "email": "taha@gmail.com",
    "password": "taha123"  # Replace with your actual password
}

print(f"Testing login for: {data['email']}")
print(f"URL: {url}")
print(f"Request body: {json.dumps(data, indent=2)}")
print("\n" + "="*50 + "\n")

try:
    response = requests.post(url, json=data, headers={'Content-Type': 'application/json'})
    
    print(f"Status Code: {response.status_code}")
    print(f"Response Headers: {dict(response.headers)}")
    print(f"\nResponse Body:")
    print(json.dumps(response.json(), indent=2))
    
    if response.status_code == 200:
        data = response.json()
        print("\n✅ Login Successful!")
        print(f"User Role: {data['user'].get('role', 'NOT FOUND')}")
        print(f"Token: {data.get('token', 'NOT FOUND')[:20]}...")
        
        if data['user'].get('role') == 'admin':
            print("✅ User has admin role - should work in dashboard")
        else:
            print("❌ User does NOT have admin role - will be rejected by dashboard")
    else:
        print("\n❌ Login Failed!")
        
except requests.exceptions.ConnectionError:
    print("❌ ERROR: Cannot connect to backend!")
    print("   Make sure the Django server is running: python manage.py runserver")
except Exception as e:
    print(f"❌ ERROR: {e}")

