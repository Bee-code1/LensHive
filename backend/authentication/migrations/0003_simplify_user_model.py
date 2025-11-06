# Generated migration to simplify User model
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('authentication', '0002_user_role'),
    ]

    operations = [
        # Add customer role to choices
        migrations.AlterField(
            model_name='user',
            name='role',
            field=models.CharField(
                choices=[('customer', 'Customer'), ('staff', 'Staff'), ('admin', 'Admin')],
                default='customer',
                max_length=10
            ),
        ),
        # Remove is_superuser field
        migrations.RemoveField(
            model_name='user',
            name='is_superuser',
        ),
        # Remove is_admin field
        migrations.RemoveField(
            model_name='user',
            name='is_admin',
        ),
        # Remove is_staff field
        migrations.RemoveField(
            model_name='user',
            name='is_staff',
        ),
    ]

