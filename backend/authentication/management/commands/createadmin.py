from django.core.management.base import BaseCommand
from authentication.models import User
import getpass

class Command(BaseCommand):
    help = 'Create an admin user for LensHive'

    def add_arguments(self, parser):
        parser.add_argument('--email', type=str, help='Admin email address')
        parser.add_argument('--name', type=str, help='Admin full name')
        parser.add_argument('--password', type=str, help='Admin password')

    def handle(self, *args, **options):
        email = options.get('email')
        full_name = options.get('name')
        password = options.get('password')

        # Interactive prompts if not provided
        if not email:
            email = input('Email address: ')
        
        if not full_name:
            full_name = input('Full name: ')
        
        if not password:
            password = getpass.getpass('Password: ')
            password_confirm = getpass.getpass('Password (again): ')
            if password != password_confirm:
                self.stdout.write(self.style.ERROR('Passwords do not match'))
                return

        # Validate email
        if not email or '@' not in email:
            self.stdout.write(self.style.ERROR('Invalid email address'))
            return

        # Check if user already exists
        if User.objects.filter(email=email).exists():
            self.stdout.write(self.style.ERROR(f'User with email {email} already exists'))
            return

        try:
            # Create admin user
            user = User.objects.create_admin(
                email=email,
                full_name=full_name,
                password=password
            )
            self.stdout.write(self.style.SUCCESS(f'Successfully created admin user: {email}'))
            self.stdout.write(self.style.SUCCESS(f'Name: {full_name}'))
            self.stdout.write(self.style.SUCCESS(f'Role: {user.role}'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error creating admin: {str(e)}'))

