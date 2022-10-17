#!/usr/bin/env bash
APPNAME=tcpdump
source "$(dirname "$(dirname "$(realpath $0)")")"/config.txt
docker exec -it "$HOSTNAME" tmux attach-session -t "$APPNAME"
