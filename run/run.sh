#!/usr/bin/env bash
source config.txt
cp template/webadmin.html.template webadmin.html
sed -i "s/IPADDR/$IPADDR:$HTTPPORT/g" webadmin.html
docker run -dit --rm \
    --name tcpdump \
    -p $IPADDR:$PORT:$PORT/$IPPROTO \
    -p $IPADDR:$HTTPPORT:$HTTPPORT \
    -v tcpdump:/var/log/tcpdump \
    -e TZ=$TZ \
    -e HTTPPORT=$HTTPPORT \
    -e IPPROTO=$IPPROTO \
    -e PORT=$PORT \
    --cap-add=NET_ADMIN \
    toddwint/tcpdump
