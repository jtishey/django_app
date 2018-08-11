FROM ubuntu:18.04

COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential autoconf pkg-config mysql-server \
  libssl-dev python3-dev python3-pip ansible apt-utils \
  vim curl apache2 apache2-utils libapache2-mod-wsgi-py3 libmysqlclient-dev

RUN sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf \
  && chmod +x /usr/local/bin/entrypoint.sh

ADD files/requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

COPY ./files/django_app.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod headers

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
VOLUME ["/var/lib/mysql"]

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]

