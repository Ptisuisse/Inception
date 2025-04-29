#!/bin/bash

# Activer les variables d'environnement depuis .env
set -a
source /inception/.env
set +a

# Initialiser la base de données (juste les fichiers système)
mysql_install_db

# Lancer mysqld temporairement en arrière-plan
mysqld_safe --skip-networking &
sleep 5  # Attendre que le serveur soit prêt

# Créer la base et l'utilisateur via des commandes SQL
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

# Arrêter MariaDB proprement
mysqladmin -u root shutdown

# Relancer mysqld en mode foreground pour Docker
exec mysqld
