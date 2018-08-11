#!/bin/bash

# Initialize data directory
DATA_DIR=/data
DATADIR=/var/lib/mysql
USER=user
PASS=password
ROOTPASS=rootpassword
DB=django_app

# If DATADIR is empty, initalize database:
if [ ! "$(ls -A $DATADIR)" ];
then
    sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
    rm -rf /var/lib/mysql/*
    mysqld --initialize-insecure 
    mkdir /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql
   
    mysqld_safe &

    # Wait for the mysqld_safe process to start
    while ! [[ "$mysqld_process_pid" =~ ^[0-9]+$ ]]; do
      mysqld_process_pid=$(echo "$(ps -C mysqld -o pid=)" | sed -e 's/^ *//g' -e 's/ *$//g')
      sleep 1
    done

    #while ! mysqladmin ping -h"$DB_HOST" --silent; do
    #    sleep 1
    #done

    /usr/bin/mysql -uroot -e "CREATE USER '$USER'@'%' IDENTIFIED BY '$PASS'"
    /usr/bin/mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%' WITH GRANT OPTION"
    /usr/bin/mysql -uroot -e "CREATE DATABASE $DB"
    /usr/bin/mysql -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$ROOTPASS')"
fi

exec "$@"
