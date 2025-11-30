What this backend uses

* Python
* Django
* Django REST Framework
* SQLite for local testing

What you need before starting

* Python installed
* Git installed
* A terminal
* No other tools required

Folder layout
ASLR_Project
Frontend        your Flutter app
Backend         your Django backend
backend     Django project code
api         your app code
venv        virtual environment (not pushed)
manage.py
requirements.txt
.gitignore
README.txt

What venv is

* A local Python environment for this backend
* Each teammate makes their own venv
* Never push venv to GitHub

How to create venv on your own PC
Open terminal in Backend folder:
python -m venv venv

How to activate venv
CMD:
venv\Scripts\activate.bat
PowerShell:
.\venv\Scripts\Activate.ps1

You must see:
(venv)
at the start of the line.

How to deactivate venv
deactivate

How to install backend packages
Inside venv:
pip install django
pip install djangorestframework

How to freeze packages for teammates
pip freeze > requirements.txt

How teammates install packages
pip install -r requirements.txt

.gitignore content you must use
venv/
**pycache**/
*.pyc
db.sqlite3

Why these are ignored

* venv is personal to each developer
* **pycache** is Python cache
* pyc files are temp files
* db.sqlite3 is your local database

How the Django project was created
In Backend folder:
django-admin startproject backend .
python manage.py startapp api

apps added in settings.py
rest_framework
api

Your model (api/models.py)
from django.db import models

class Task(models.Model):
title = models.CharField(max_length=200)
done = models.BooleanField(default=False)
created_at = models.DateTimeField(auto_now_add=True)

Your serializer (api/serializers.py)
from rest_framework import serializers
from .models import Task

class TaskSerializer(serializers.ModelSerializer):
class Meta:
model = Task
fields = "**all**"

Your view (api/views.py)
from rest_framework import viewsets
from .models import Task
from .serializers import TaskSerializer

class TaskViewSet(viewsets.ModelViewSet):
queryset = Task.objects.all().order_by("-created_at")
serializer_class = TaskSerializer

Your api routes (api/urls.py)
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import TaskViewSet

router = DefaultRouter()
router.register("tasks", TaskViewSet)

urlpatterns = [
path("", include(router.urls)),
]

Main routes (backend/urls.py)
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
path("admin/", admin.site.urls),
path("api/", include("api.urls")),
]

How to create database tables
python manage.py makemigrations api
python manage.py migrate

How to run backend
python manage.py runserver

Where to access API in browser
[http://127.0.0.1:8000/api/tasks/](http://127.0.0.1:8000/api/tasks/)

If the page shows an empty list [], backend works.

What to commit to GitHub

* backend folder
* api folder
* manage.py
* requirements.txt
* .gitignore
* README.txt

What not to commit

* venv
* db.sqlite3
* pycache files

