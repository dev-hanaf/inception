#!/bin/bash

set -eu

chown -R mysql:mysql /var/lib/mysql

mysql_install_db

echo "running mariadb in background"
mysqld --skip_networking &
MYSQL_PID=$!

echo "Waiting for MariaDB..."
until mysqladmin ping > /dev/null 2>&1 \
   || mysqladmin -uroot -p"${DB_ROOT_PASSWORD}" ping > /dev/null 2>&1; do
    echo "  still waiting..."
    sleep 1
done


echo "creating database..."

if mysqladmin -uroot -p"${DB_ROOT_PASSWORD}" ping > /dev/null 2>&1; then
    MARIADB="mariadb -uroot -p$DB_ROOT_PASSWORD"
else
    MARIADB="mariadb"
fi

echo "hellooooooooooooooooooooooooooooooooooo world"

${MARIADB} << EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS'${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "killing background mariadb"
kill $MYSQL_PID
wait $MYSQL_PID 2>/dev/null || true

echo "running mariadb in foreground..."
mysqld

