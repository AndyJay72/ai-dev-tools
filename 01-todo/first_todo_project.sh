cd /workspaces/ai-dev-tools && bash << 'SCRIPT'
#!/bin/bash
# Create main project directory
mkdir -p todo_project
cd todo_project

# Top-level files with sample content
cat > Dockerfile <<EOF
# Sample Dockerfile
FROM python:3.11
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["./entrypoint.sh"]
EOF

cat > docker-compose.yml <<EOF
version: '3'
services:
  web:
    build: .
    command: ./entrypoint.sh
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    env_file:
      - .env
EOF

cat > entrypoint.sh <<EOF
#!/bin/bash
# Sample entrypoint script
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
EOF
chmod +x entrypoint.sh

cat > requirements.txt <<EOF
Django>=4.2
EOF

cat > .env <<EOF
DEBUG=1
SECRET_KEY=your-secret-key
EOF

cat > pytest.ini <<EOF
[pytest]
DJANGO_SETTINGS_MODULE = todo_project.settings
python_files = tests.py test_*.py *_tests.py
EOF

cat > conftest.py <<EOF
import pytest
# Add your pytest fixtures here
EOF

# Django project files with sample content
mkdir -p todo_project

cat > todo_project/__init__.py <<EOF
# Init file for todo_project
EOF

cat > todo_project/settings.py <<EOF
# Basic Django settings
SECRET_KEY = 'your-secret-key'
DEBUG = True
ALLOWED_HOSTS = ['*']
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'tasks',
]
ROOT_URLCONF = 'todo_project.urls'
WSGI_APPLICATION = 'todo_project.wsgi.application'
EOF

cat > todo_project/urls.py <<EOF
from django.urls import path, include

urlpatterns = [
    path('tasks/', include('tasks.urls')),
]
EOF

cat > todo_project/wsgi.py <<EOF
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'todo_project.settings')

application = get_wsgi_application()
EOF

# Tasks app files with sample content
mkdir -p tasks/migrations
mkdir -p tasks/templates

cat > tasks/__init__.py <<EOF
# Tasks app
EOF

cat > tasks/models.py <<EOF
from django.db import models

class Task(models.Model):
    title = models.CharField(max_length=255)
    completed = models.BooleanField(default=False)
EOF

cat > tasks/views.py <<EOF
from django.shortcuts import render
from .models import Task

def task_list(request):
    tasks = Task.objects.all()
    return render(request, 'tasks/task_list.html', {'tasks': tasks})
EOF

cat > tasks/forms.py <<EOF
from django import forms
from .models import Task

class TaskForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = ['title', 'completed']
EOF

cat > tasks/urls.py <<EOF
from django.urls import path
from . import views

urlpatterns = [
    path('', views.task_list, name='task_list'),
]
EOF

cat > tasks/admin.py <<EOF
from django.contrib import admin
from .models import Task

admin.site.register(Task)
EOF

cat > tasks/apps.py <<EOF
from django.apps import AppConfig

class TasksConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'tasks'
EOF

touch tasks/migrations/__init__.py
touch tasks/templates/.gitkeep

# Tests directory and files with sample content
mkdir -p tests

cat > tests/__init__.py <<EOF
# Tests package
EOF

cat > tests/test_models.py <<EOF
from tasks.models import Task

def test_task_creation():
    task = Task(title="Test", completed=False)
    assert task.title == "Test"
    assert not task.completed
EOF

cat > tests/test_forms.py <<EOF
from tasks.forms import TaskForm

def test_task_form_valid():
    form = TaskForm(data={'title': 'Test', 'completed': False})
    assert form.is_valid()
EOF

cat > tests/test_views_crud.py <<EOF
def test_crud_operations(client):
    # Add CRUD operation tests here
    pass
EOF

cat > tests/test_views_list.py <<EOF
def test_task_list_view(client):
    response = client.get('/tasks/')
    assert response.status_code == 200
EOF

cat > tests/test_completion.py <<EOF
def test_completion_feature():
    # Test completion logic here
    pass
EOF

cat > manage.py <<EOF
#!/usr/bin/env python
import os
import sys

def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'todo_project.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError("Django not installed") from exc
    execute_from_command_line(sys.argv)

if __name__ == '__main__':
    main()
EOF
chmod +x manage.py

echo "Project structure created!"
SCRIPT