FROM debian:bullseye

RUN apt update && apt install -y wget tar

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz && \
    tar -xvf prometheus-2.52.0.linux-amd64.tar.gz && \
    mv prometheus-2.52.0.linux-amd64 /etc/prometheus

WORKDIR /etc/prometheus
CMD ["./prometheus", "--config.file=prometheus.yml"]