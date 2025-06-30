FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        php7.4-fpm \
        php7.4-mysqli \
        php7.4-redis \
        php7.4-curl \
        curl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

RUN mkdir -p /run/php

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

EXPOSE 9000

CMD ["/script.sh"]
