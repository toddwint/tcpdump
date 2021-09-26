#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo $HOSTNAME > /etc/hostname

nohup tcpdump -i eth0 -AXnvv -l "$IPPROTO port $PORT" >> /var/log/tcpdump/tcpdump.log &

frontail -d -p $HTTPPORT /var/log/tcpdump/tcpdump.log

# Keep docker running
bash
