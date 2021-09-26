FROM ubuntu:focal
COPY scripts /opt/tcpdump/scripts
EXPOSE 9001 8601/udp
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    HTTPPORT=9001 \
    HOSTNAME=tcpdumpsrvr \
    IPPROTO=udp \
    PORT=8601
RUN apt-get update \
    && \
    apt-get install -y \
    tzdata \
    iproute2 \
    wget \
    tcpdump \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    wget -q https://github.com/mthenw/frontail/releases/download/v4.9.1/frontail-linux -O /usr/local/bin/frontail \
    && \
    chmod 755 /usr/local/bin/frontail \
    && \
    apt-get remove -y \
    wget \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/tcpdump
CMD ["/opt/tcpdump/scripts/startup.sh"]
