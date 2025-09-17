#!/bin/bash
# Add comments to lines 5-10
#:5,10s/^/# /

# Remove comments from lines 5-10
#:5,10s/^# //

set -e


if php wp-cli.phar --info > /dev/null 2>&1; then
    echo "WP-CLI phar file is valid and working"
else
    rm -f wp-cli.phar
    # Re-download WP-CLI
    if curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; then
        # Test again
        if php wp-cli.phar --info > /dev/null 2>&1; then
            echo "Re-downloaded WP-CLI is working"
        else
            echo "ERROR: Re-downloaded WP-CLI still not working"
            exit 1
        fi
    else
        echo "ERROR: Failed to re-download WP-CLI"
        exit 1
    fi
fi


wp core download --allow-root

#wp core install \
#         --url="https://localhost" \
#         --title="My WordPress Site" \
#         --admin_user="admin" \
#         --admin_password="admin123" \
#         --admin_email="admin@example.com" \
#         --allow-root


if [ ! -f wp-config.php ]; then
    cp -r /data/* /var/www/html/

fi

chown -R www-data:www-data /var/www/html

php-fpm8.2 -F


