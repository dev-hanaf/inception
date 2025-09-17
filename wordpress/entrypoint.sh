#!/bin/bash


#chown -R www-data:www-data /var/www/html


#php-fpm8.2 -F

set -e

# If target is empty, copy WordPress files there
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Initializing WordPress in /var/www/html..."
    cp -r /usr/src/wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

php-fpm8.2 -F


