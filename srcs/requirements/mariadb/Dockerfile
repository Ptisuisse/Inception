
FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y mariadb-server

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY script.sh /script.sh

RUN chmod +x script.sh

CMD ["bash", "./script.sh"]
