#!bin/bash

if [ -d "/var/lib/mysql/${DB_NAME}" ]; then
    echo "Base de données ${DB_NAME} déjà initialisée."
else
    echo "Initialisation de MariaDB..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql

    # Démarrer MariaDB temporairement en arrière-plan
    mysqld_safe --skip-networking &
    sleep 5  # attendre que MariaDB démarre

    echo "Création de la base de données et de l'utilisateur..."

    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Arrêter le serveur temporaire
    mysqladmin -u root shutdown
fi

# Lancer MariaDB normalement
exec mysqld
