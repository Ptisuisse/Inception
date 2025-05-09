FROM debian:bullseye

WORKDIR /var/www/static-site

RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs npm && \
    rm -rf /var/lib/apt/lists/*

RUN chmod -R 777 /

RUN npm install -g http-server --no-update-notifier --no-fund

CMD ["http-server", "-p", "8080", "-d", "/var/www/static-site"]
