#!/bin/bash
docker run -it -p 80:80 -v `pwd`/app:/var/www/django_app -v `pwd`/mysql:/var/lib/mysql --name django_app django_app
