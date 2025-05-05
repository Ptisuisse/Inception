#!/bin/bash

WP_PATH="/var/www/wordpress"
WP_CONFIG_PATH="$WP_PATH/wp-config.php"

# Aller dans le répertoire WordPress
cd $WP_PATH

# Vérifier si wp-cli existe, sinon le télécharger
if [ ! -f wp-cli.phar ]; then
    echo "Downloading wp-cli..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

# Attendre que MariaDB soit prête (simple sleep, peut être amélioré)
echo "Waiting for MariaDB..."
sleep 15

# Vérifier si wp-config.php existe déjà
if [ ! -f "$WP_CONFIG_PATH" ]; then
    echo "Downloading WordPress Core..."
    ./wp-cli.phar core download --allow-root

    echo "Creating wp-config.php..."
    ./wp-cli.phar config create --dbname=$DB_NAME \
                                --dbuser=$DB_USER \
                                --dbpass=$DB_PASSWORD \
                                --dbhost=$DB_HOST \
                                --allow-root
else
    echo "wp-config.php already exists."
fi

# Vérifier si WordPress est déjà installé
if ! ./wp-cli.phar core is-installed --allow-root; then
    echo "Installing WordPress..."
    ./wp-cli.phar core install --url=$WP_ADMIN_URL \
                               --title="$WP_ADMIN_TITLE" \
                               --admin_user=$WP_ADMIN_USER \
                               --admin_password=$WP_ADMIN_PASSWORD \
                               --admin_email=$WP_ADMIN_EMAIL \
                               --skip-email \
                               --allow-root
    # L'option --skip-email évite l'erreur sendmail si sendmail n'est pas installé

    echo "Creating additional user..."
    ./wp-cli.phar user create $WP_USER_NAME $WP_USER_EMAIL --role=$WP_USER_ROLE --user_pass=$WP_USER_PASSWORD --allow-root
else
    echo "WordPress is already installed."
fi

# --- Configuration Redis ---
echo "Configuring Redis constants in wp-config.php..."

# Définir la bonne ancre
WP_CONFIG_ANCHOR="/* That's all, stop editing! Happy publishing. */"

# Vérifier si l'ancre existe avant d'essayer d'ajouter des constantes
if grep -qF "$WP_CONFIG_ANCHOR" "$WP_CONFIG_PATH"; then

    # Garder --raw pour les nombres et booléens, l'enlever pour les chaînes
    ./wp-cli.phar config set WP_REDIS_HOST "$WP_REDIS_HOST" --anchor="$WP_CONFIG_ANCHOR" --allow-root
    ./wp-cli.phar config set WP_REDIS_PORT "$WP_REDIS_PORT" --raw --anchor="$WP_CONFIG_ANCHOR" --allow-root
    ./wp-cli.phar config set WP_REDIS_DATABASE "$WP_REDIS_DATABASE" --raw --anchor="$WP_CONFIG_ANCHOR" --allow-root
    ./wp-cli.phar config set WP_REDIS_TIMEOUT "$WP_REDIS_TIMEOUT" --raw --anchor="$WP_CONFIG_ANCHOR" --allow-root
    ./wp-cli.phar config set WP_REDIS_READ_TIMEOUT "$WP_REDIS_READ_TIMEOUT" --raw --anchor="$WP_CONFIG_ANCHOR" --allow-root
    ./wp-cli.phar config set WP_REDIS_CLIENT "$WP_REDIS_CLIENT" --anchor="$WP_CONFIG_ANCHOR" --allow-root
    # Utiliser la variable dédiée pour le préfixe, sans --raw pour les guillemets
    ./wp-cli.phar config set WP_CACHE_KEY_SALT "$WP_REDIS_SALT_PREFIX" --anchor="$WP_CONFIG_ANCHOR" --allow-root
    # Utiliser la variable dédiée pour activer/désactiver, avec --raw car c'est un booléen
    ./wp-cli.phar config set WP_CACHE "$WP_REDIS_CACHE_ENABLED" --raw --anchor="$WP_CONFIG_ANCHOR" --allow-root

    echo "Redis constants added/updated from .env."

else
    echo "ERROR: Could not find anchor '$WP_CONFIG_ANCHOR' in $WP_CONFIG_PATH. Cannot add Redis constants automatically."
fi


# Installer et activer le plugin Redis après la configuration
if ! ./wp-cli.phar plugin is-installed redis-cache --allow-root; then
    echo "Installing redis-cache plugin..."
    ./wp-cli.phar plugin install redis-cache --activate --allow-root
else
    echo "redis-cache plugin already installed."
    # S'assurer qu'il est actif
    ./wp-cli.phar plugin activate redis-cache --allow-root
fi

# Activer l'object cache Redis (crée object-cache.php)
echo "Enabling Redis Object Cache..."
# Vérifier si la connexion fonctionne avant d'activer
if ./wp-cli.phar redis status --allow-root; then
    ./wp-cli.phar redis enable --allow-root
    echo "Redis Object Cache enabled successfully."
else
    echo "WARNING: Could not connect to Redis or wp-config.php has errors. Object Cache not enabled."
fi



# --- Définir les bonnes permissions ---
echo "Setting ownership for /var/www/wordpress to www-data..."
# Changer la propriété de l'ensemble du répertoire WordPress
# Cela est souvent nécessaire pour les mises à jour et la gestion des plugins/thèmes
chown -R www-data:www-data "$WP_PATH"

echo "Starting PHP-FPM..."
# Exécuter php-fpm en avant-plan pour garder le conteneur actif
php-fpm7.4 -F

echo "Script finished (should not reach here if php-fpm started correctly)."