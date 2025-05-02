
FROM debian:bullseye

RUN apt update

RUN apt upgrade -y

RUN apt install -y php7.4-fpm

RUN apt install -y php7.4-mysqli curl

RUN apt install unzip

RUN mkdir -p /run/php && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/script.sh /script.sh

RUN chmod +x script.sh

CMD ["bash", "/script.sh"]
