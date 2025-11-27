#!/bin/bash
set -e

# Create main project directory
mkdir -p todo_project
cd todo_project

# Dockerfile
cat > Dockerfile <<EOF
FROM python:3.11
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
EOF

# docker-compose.yml
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

# entrypoint.sh
cat > entrypoint.sh <<EOF
#!/bin/bash
set -e
python manage.py migrate
exec python manage.py runserver 0.0.0.0:8000
EOF
chmod +x entrypoint.sh

# requirements.txt
cat > requirements.txt <<EOF
Django>=4.2
pytest
pytest-django
EOF

# .env
cat > .env <<EOF
DEBUG=1
SECRET_KEY=your-secret-key
EOF

# pytest.ini
cat > pytest.ini <<EOF
[pytest]
DJANGO_SETTINGS_MODULE = todo_project.settings
python_files = tests.py test_*.py *_tests.py
EOF

# conftest.py
cat > conftest.py <<EOF
import pytest
from django.test import Client

@pytest.fixture
def client():
    return Client()
EOF

# Django project files
mkdir -p todo_project

cat > todo_project/__init__.py <<EOF
# Init file for todo_project
EOF

cat > todo_project/settings.py <<EOF
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

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

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'todo_project.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'todo_project.wsgi.application'
ASGI_APPLICATION = 'todo_project.asgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

STATIC_URL = 'static/'
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
EOF

cat > todo_project/urls.py <<EOF
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('tasks/', include('tasks.urls')),
]
EOF

cat > todo_project/wsgi.py <<EOF
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'todo_project.settings')
application = get_wsgi_application()
EOF

cat > todo_project/asgi.py <<EOF
import os
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'todo_project.settings')
application = get_asgi_application()
EOF

# Tasks app files
mkdir -p tasks/migrations
mkdir -p tasks/templates/tasks

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

# Minimal template
cat > tasks/templates/tasks/task_list.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Tasks</title>
</head>
<body>
    <h1>Task List</h1>
    <ul>
        {% for task in tasks %}
            <li>{{ task.title }} - {% if task.completed %}Done{% else %}Pending{% endif %}</li>
        {% endfor %}
    </ul>
</body>
</html>
EOF

# Tests
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

# manage.py
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

echo "🎉 Django TODO App project scaffolded and Docker-ready!"