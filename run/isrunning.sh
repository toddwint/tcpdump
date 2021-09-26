#!/usr/bin/env bash
running=$(docker ps | grep tcpdump | wc -l)
if [ $running -eq 1 ]
then
    echo "Yes. It is running. Look:  "
    docker ps | grep tcpdump
else
    echo "He's dead Jim."
fi
