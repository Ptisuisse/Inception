# Utiliser Debian Bullseye comme image de base
FROM debian:bullseye

# Mettre à jour les paquets et installer Redis
RUN apt update && \
    apt install -y redis-server && \
    apt clean

# Exposer le port 6379 pour Redis
EXPOSE 6379

# Commande par défaut pour démarrer Redis
CMD ["redis-server", "/etc/redis/redis.conf"]

