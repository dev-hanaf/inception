#!/bin/sh

set -eu

#export WP_CLI_PHP_ARGS="-d memory_limit=512M"
if [ ! -f wp-settings.php ]; then
    echo ">>>>>>>>>>>>>>Downloading WordPress..."
   # wp core download --allow-root
   php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

else
    echo ">>>>>>>>>>>>>>WordPress Already Downloaded!"
fi


chown -R www-data:www-data /var/www/html


echo ">>>>>>>>>>>>>>Waiting for mariadb..."
while ! /usr/bin/mariadb-admin ping -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASSWORD}" --silent; do
	echo ">>>>>>>>>>>>>>Database is unavailable - sleeping..."
	sleep 2
done


if [ ! -f wp-config.php ]; then
	echo ">>>>>>>>>>>>>>Copying wp-config.php..."
	#mv /tmp/wp-config.php wp-config.php
        # Create wp-config.php
        php -d memory_limit=512M /usr/local/bin/wp config create \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=$DB_HOST_PORT \
        --locale=en_US \
        --allow-root
    
else
	echo ">>>>>>>>>>>>>>wp-config.php Present"
fi


WP_ADMIN_PASS=superpassword
if ! wp core is-installed --allow-root; then
	echo ">>>>>>>>>>>>>>Installing Wordpress..."
	#wp core install \
        php -d memory_limit=512M /usr/local/bin/wp core install \
        --url="${URL}" \
        --title="${TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email --allow-root

else
	echo ">>>>>>>>>>>>>>Wordpress Already Installed!"
fi


exec php-fpm83 -F
