#!/bin/bash


chown -R www-data:www-data /var/www/html

until mysql  -h mariadb -u $DB_USER -p$DB_PASSWORD -e "SELECT 1" &> /dev/null; do
    echo "Waiting for MariaDB connection..."
    sleep 2
done


# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."
    
    # Download WordPress core files
    wp core download --locale=en_US --allow-root
    
    # Create wp-config.php
    wp config create \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=mariadb:3306 \
        --locale=en_US \
        --allow-root
    
    # Install WordPress
    wp core install \
        --url="https://localhost:8080" \
        --title="My WordPress Site" \
        --admin_user="admin" \
        --admin_password="admin_password" \
        --admin_email="admin@example.com" \
        --allow-root
    
    echo "WordPress installation completed!"
else
    echo "WordPress is already installed."
fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F


