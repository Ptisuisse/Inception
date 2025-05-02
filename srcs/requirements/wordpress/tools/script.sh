#!/bin/bash

cd /var/www/wordpress

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

sleep 10

./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --allow-root
./wp-cli.phar core install --url=$WP_ADMIN_PASSWORD --title=$WP_ADMIN_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
./wp-cli.phar user create $WP_USER_NAME $WP_USER_EMAIL --role=$WP_USER_ROLE --user_pass=$WP_USER_PASSWORD --allow-root

echo "define( 'WP_REDIS_HOST', 'redis' );" >> /var/www/wordpress/wp-config.php
echo "define( 'WP_REDIS_PORT', '6379' );" >> /var/www/wordpress/wp-config.php
echo "define( 'WP_REDIS_DATABASE', '0' );" >> /var/www/wordpress/wp-config.php
echo "define( 'WP_REDIS_TIMEOUT', 1 );" >> /var/www/wordpress/wp-config.php
echo "define( 'WP_REDIS_READ_TIMEOUT', 1 );" >> /var/www/wordpress/wp-config.php

wp plugin install redis-cache --allow-root
wp plugin activate redis-cache --allow-root

# Activer Redis comme cache
wp redis enable --allow-root

php-fpm7.4 -F

