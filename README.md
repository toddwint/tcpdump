# toddwint/tcpdump

## Info

`tcpdump` docker image for simple lab testing applications.

Docker Hub: <https://hub.docker.com/r/toddwint/tcpdump>

GitHub: <https://github.com/toddwint/tcpdump>


## Features

- Ubuntu base image
- Plus:
  - tcpdump
  - tmux
  - python3-minimal
  - iproute2
  - tzdata
  - [ttyd](https://github.com/tsl0922/ttyd)
    - View the terminal in your browser
  - [frontail](https://github.com/mthenw/frontail)
    - View logs in your browser
    - Mark/Highlight logs
    - Pause logs
    - Filter logs
  - [tailon](https://github.com/gvalkov/tailon)
    - View multiple logs and files in your browser
    - User selectable `tail`, `grep`, `sed`, and `awk` commands
    - Filter logs and files
    - Download logs to your computer


## Sample `config.txt` file

```
TZ=UTC
INTERFACE=eth0
IPADDR=192.168.1.1
MGMTIP=192.168.1.2
SUBNET=192.168.1.0/24
GATEWAY=192.168.1.254
ROTATE_SECONDS=300
EXPRESSION=
EXPRESSION_TYPE=
HTTPPORT1=8080
HTTPPORT2=8081
HTTPPORT3=8082
HTTPPORT4=8083
HOSTNAME=tcpdumpsrvr01
```


## Sample docker run script

```
#!/usr/bin/env bash
REPO=toddwint
APPNAME=tcpdump
HUID=$(id -u)
HGID=$(id -g)
source "$(dirname "$(realpath $0)")"/config.txt

# Make the macvlan needed to listen on ports
docker network create -d macvlan --subnet="$SUBNET" --gateway="$GATEWAY" \
  --aux-address="mgmt_ip=$MGMTIP" -o parent="$INTERFACE" \
  "$HOSTNAME"
sudo ip link add "$HOSTNAME" link "$INTERFACE" type macvlan mode bridge
sudo ip addr add "$MGMTIP"/32 dev "$HOSTNAME"
sudo ip link set "$HOSTNAME" up
sudo ip route add "$IPADDR"/32 dev "$HOSTNAME"

# Create the docker container
docker run -dit \
    --name "$HOSTNAME" \
    --net="$HOSTNAME" \
    --ip $IPADDR \
    -h "$HOSTNAME" \
    -v "$(pwd)"/captures:/opt/"$APPNAME"/scripts/captures \
    -p "$IPADDR":"$HTTPPORT1":"$HTTPPORT1" \
    -p "$IPADDR":"$HTTPPORT2":"$HTTPPORT2" \
    -p "$IPADDR":"$HTTPPORT3":"$HTTPPORT3" \
    -p "$IPADDR":"$HTTPPORT4":"$HTTPPORT4" \
    -e TZ="$TZ" \
    -e ROTATE_SECONDS="$ROTATE_SECONDS" \
    -e EXPRESSION="$EXPRESSION" \
    -e EXPRESSION_TYPE="$EXPRESSION_TYPE" \
    -e HUID="$HUID" \
    -e HGID="$HGID" \
    -e HTTPPORT1="$HTTPPORT1" \
    -e HTTPPORT2="$HTTPPORT2" \
    -e HTTPPORT3="$HTTPPORT3" \
    -e HTTPPORT4="$HTTPPORT4" \
    -e HOSTNAME="$HOSTNAME" \
    -e APPNAME="$APPNAME" \
    `# --cap-add=NET_ADMIN \ ` \
    ${REPO}/${APPNAME}
```


## Login page

Open the `webadmin.html` file.

- Or just type in your browser: 
  - `http://<ip_address>:<port1>` or
  - `http://<ip_address>:<port2>` or
  - `http://<ip_address>:<port3>`
  - `http://<ip_address>:<port4>`


## Issues?

Make sure to set the IP on the host and that the ports being used are not currently being used by the host.
