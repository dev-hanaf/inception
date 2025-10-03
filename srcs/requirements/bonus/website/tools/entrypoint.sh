#!/bin/sh

chown -R www-data:www-data /var/www/html

cp /tmp/index.html /var/www/html/index.html
cp /tmp/style.css /var/www/html/style.css

exec nginx -g "daemon off;"