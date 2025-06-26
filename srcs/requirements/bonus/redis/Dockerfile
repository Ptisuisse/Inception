FROM debian:bullseye

RUN apt-get update && apt-get install -y lsb-release curl gpg redis-server
COPY conf/redis.conf /var/www/redis.conf
RUN mv /var/www/redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]