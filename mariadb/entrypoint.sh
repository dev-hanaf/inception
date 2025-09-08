#!/bin/bash

set -eu

DB_NAME=wordpress
DB_USER=wp-user
DB_PASSWORD=ahanaf123
DB_ROOT_PASSWORD=root123

echo "running mariadb in background"
mysqld --skip_networking &
MYSQL_PID=$!

echo "Waiting for MariaDB..."
until mysqladmin ping --silent \
   || mysqladmin -uroot -p"${DB_ROOT_PASSWORD}" ping --silent; do
    echo "  still waiting..."
    sleep 1
done


echo "creating database..."

mariadb << EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
USE ${DB_NAME};
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "killing background mariadb"
kill $MYSQL_PID
wait $MYSQL_PID 2>/dev/null || true

echo "running mariadb in foreground..."
mysqld

