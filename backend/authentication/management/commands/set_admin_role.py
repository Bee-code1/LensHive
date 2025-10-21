from django.core.management.base import BaseCommand
from authentication.models import User

class Command(BaseCommand):
    help = 'Set user role to admin'

    def add_arguments(self, parser):
        parser.add_argument('email', type=str, help='Email of the user to make admin')

    def handle(self, *args, **options):
        email = options['email']
        try:
            user = User.objects.get(email=email)
            user.role = 'admin'
            user.is_staff = True
            user.is_admin = True
            user.save()
            self.stdout.write(self.style.SUCCESS(f'Successfully made {email} an admin'))
        except User.DoesNotExist:
            self.stdout.write(self.style.ERROR(f'User with email {email} does not exist'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error: {str(e)}'))