#!/bin/bash

required_vars=("FTP_USER_NAME" "FTP_USER_PASS")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "ERREUR: Variable d'environnement requise manquante : $var"
        exit 1
    fi
done

if ! id "$FTP_USER_NAME" &>/dev/null; then
    useradd -m "$FTP_USER_NAME"
    if [ $? -ne 0 ]; then
        echo "ERREUR: Échec de la création de l'utilisateur $FTP_USER_NAME."
        exit 1
    fi
else
    echo "L'utilisateur $FTP_USER_NAME existe déjà."
fi

echo "$FTP_USER_NAME:$FTP_USER_PASS" | chpasswd
if [ $? -ne 0 ]; then
    echo "ERREUR: Échec de la définition du mot de passe pour $FTP_USER_NAME."
    exit 1
fi

> /etc/vsftpd.userlist
echo "$FTP_USER_NAME" >> /etc/vsftpd.userlist
if [ $? -ne 0 ]; then
    echo "ERREUR: Échec de l'écriture dans /etc/vsftpd.userlist."
    exit 1
fi
echo "Contenu de /etc/vsftpd.userlist :"
cat /etc/vsftpd.userlist

usermod -d /var/www/wordpress "$FTP_USER_NAME"
if [ $? -ne 0 ]; then
    echo "AVERTISSEMENT: Échec de la définition du répertoire racine pour $FTP_USER_NAME (usermod -d). Vérifiez les logs précédents."
fi

if [ ! -d "/var/run/vsftpd/empty" ]; then
    echo "ERREUR FATALE: Le répertoire /var/run/vsftpd/empty est manquant!"
    exit 1
else
    echo "Répertoire /var/run/vsftpd/empty trouvé."
fi

echo "--- Démarrage de vsftpd ---"

exec /usr/sbin/vsftpd /etc/vsftpd.conf