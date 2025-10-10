#!/bin/sh

set -eu

echo "Reading secrets..."

if [ ! -f /run/secrets/db_password ]; then
    echo "ERROR: db_password secret not found!"
    exit 1
fi

if [ ! -f /run/secrets/wp_admin_password ]; then
    echo "ERROR: wp_admin_password secret not found!"
    exit 1
fi

# Read passwords from secret files
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX"
echo "DB_PASSWORD: $DB_PASSWORD"
echo "WP_ADMIN_PASSWORD: $WP_ADMIN_PASSWORD"
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX"

echo "Secrets loaded successfully!"



if [ ! -f wp-settings.php ]; then
    echo ">>>>>>>>>>>>>>Downloading WordPress..."
    wp core download --allow-root
   #php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

else
    echo ">>>>>>>>>>>>>>WordPress Already Downloaded!"
fi


chown -R www-data:www-data /var/www/html


echo ">>>>>>>>>>>>>>Waiting for mariadb..."
while ! /usr/bin/mariadb-admin ping -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASSWORD}" --silent; do
	echo ">>>>>>>>>>>>>>Database is unavailable - sleeping..."
	sleep 2
done


# if [ ! -f wp-config.php ]; then
# 	echo ">>>>>>>>>>>>>>Copying wp-config.php..."
# 	mv /tmp/wp-config.php /var/www/html/wp-config.php
# else
# 	echo ">>>>>>>>>>>>>>wp-config.php Present"
# fi

if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    
    # Create wp-config.php using WP-CLI
    wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${DB_HOST_PORT}" \
        --locale=en_US \
        --allow-root
    
    echo "✅ wp-config.php created!"
    
    # ========================================
    # ADD REDIS CONFIGURATION
    # ========================================
    echo "Configuring Redis..."
    wp config set WP_REDIS_HOST "${REDIS_HOST}" --allow-root
    wp config set WP_REDIS_PORT "${REDIS_PORT}" --raw --allow-root
    wp config set WP_CACHE true --raw --allow-root
    
    # ========================================
    # ADD SECURITY SETTINGS
    # ========================================
    echo "Adding security settings..."
    wp config set FORCE_SSL_ADMIN true --raw --allow-root
    wp config set FORCE_SSL_LOGIN true --raw --allow-root
    
    # ========================================
    # GENERATE SECURITY KEYS
    # ========================================
    echo "Generating WordPress security keys..."
    wp config shuffle-salts --allow-root
    
    echo "✅ Configuration complete!"
else
    echo "✅ wp-config.php already exists!"
fi
# if [ ! -f wp-config.php ]; then
# 	echo ">>>>>>>>>>>>>>Copying wp-config.php..."
# 	#mv /tmp/wp-config.php wp-config.php
#         # Create wp-config.php
#         php -d memory_limit=512M /usr/local/bin/wp config create \
#         --dbname=$DB_NAME \
#         --dbuser=$DB_USER \
#         --dbpass=$DB_PASSWORD \
#         --dbhost=$DB_HOST_PORT \
#         --locale=en_US \
#         --allow-root
#     
# else
# 	echo ">>>>>>>>>>>>>>wp-config.php Present"
# fi


# WP_ADMIN_PASS=superpassword
if ! wp core is-installed --allow-root; then
	echo ">>>>>>>>>>>>>>Installing Wordpress..."
	    wp core install \
        --url="${URL}" \
        --title="${TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email --allow-root

else
	echo ">>>>>>>>>>>>>>Wordpress Already Installed!"
fi


echo "Waiting for Redis at $REDIS_HOST:$REDIS_PORT ..."

# Loop until redis-cli returns PONG
until redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" ping 2>/dev/null; do
    echo "Redis is not ready yet..."
    sleep 2
done

echo "✅ Redis is up and running!"


if ! wp plugin is-installed redis-cache --allow-root; then
	echo ">>>>>>>>>>>>Installing Redis Object Cache plugin..."
	wp plugin install redis-cache --activate --allow-root
	wp redis enable --allow-root
else
	echo ">>>>>>>>>>>>Redis Object Cache plugin is already installed."
	if ! wp plugin is-active redis-cache --allow-root; then
		echo ">>>>>>>>>>>Activate Redis Object Cache plugin..."
		wp plugin activate redis-cache --allow-root
		wp redis enable --allow-root
	fi
fi


exec php-fpm83 -F
