
Docker container with Python3, Django, Apache, and MySQL

Sets up a template project named django_app

To get started:

`cd django_app`

`docker build -t django_app .`

`./run.sh`

`docker exec -it django_app bash`

`python3 /var/www/django_app/manage.py migrate`


Browse to http://127.0.0.1


mysql db stored in ./mysql directory on host

django project stored in ./app directory on host

