FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y vsftpd procps passwd

RUN mkdir -p /var/run/vsftpd/empty && \
    chown ftp:ftp /var/run/vsftpd/empty && \
    chmod 755 /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 21

CMD ["bash", "/usr/local/bin/script.sh"]