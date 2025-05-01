FROM debian:bullseye

RUN apt-get update
RUN apt-get install -y nginx openssl
RUN apt-get clean

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=FR/ST=IDF/L=Paris/O=Test/OU=Dev/CN=lvan-slu.42.fr"

COPY /conf/default /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]

