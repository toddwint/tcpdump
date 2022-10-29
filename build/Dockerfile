FROM toddwint/mybaseimage
COPY app /opt/tcpdump
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    ROTATE_SECONDS=300 \
    EXPRESSION= \
    EXPRESSION_TYPE= \
    HUID=1001 \
    HGID=1001 \
    HTTPPORT1=8080 \
    HTTPPORT2=8081 \
    HTTPPORT3=8082 \
    HTTPPORT4=8083 \
    HOSTNAME=tcpdumpsrvr \
    APPNAME=tcpdump
# tcpdump version > 4.99 is required. Focal only has version 4.9.3
#RUN echo 'deb http://archive.ubuntu.com/ubuntu/ jammy main' >> /etc/apt/sources.list \
#    && \
#    echo 'deb-src http://archive.ubuntu.com/ubuntu/ jammy main' >> /etc/apt/sources.list \ 
#    && \
RUN apt-get update \
    && \
    apt-get install -y \
    tcpdump \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/tcpdump/debug
CMD ["/opt/tcpdump/scripts/startup.sh"]
