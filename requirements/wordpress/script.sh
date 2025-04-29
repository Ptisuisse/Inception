#!/bin/bash

set -a
source /inception/.env
set +a

cd /var/www/wordpress

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --allow-root
./wp-cli.phar core install --url=lvan-slu.42.fr --title=Inception --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
./wp-cli.phar user create $WP_USER_NAME $WP_USER_EMAIL --role=subscriber --user_pass=$WP_USER_PASSWORD --allow-root

php-fpm7.4 -F
