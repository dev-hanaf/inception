#!/bin/sh

set -eu

chown -R www-data:www-data /var/www/html

exec php-fpm83 -F
