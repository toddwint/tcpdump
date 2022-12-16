# toddwint/tcpdump

## Info

`tcpdump` docker image for simple lab testing applications.

Docker Hub: <https://hub.docker.com/r/toddwint/tcpdump>

GitHub: <https://github.com/toddwint/tcpdump>


## Overview

- Download the docker image and github files.
- Configure the settings in `run/config.txt`.
- Start a new container by running `run/create_container.sh`. The folder `captures` will be created as specified in the `create_container.sh` script.
- Open the file webadmin.html to view messages in a web browser.
- Traffic is saved in the `captures` folder timestamped at the interval set by the configuration file.


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
# To get a list of timezones view the files in `/usr/share/zoneinfo`
TZ=UTC

# The interface on which to set the IP. Run `ip -br a` to see a list
INTERFACE=eth0

# The IP address that will be set on the docker container
IPADDR=192.168.10.1

# The IP address that will be set on the host to manage the docker container
MGMTIP=192.168.10.2

# The IP subnet in the form subnet/cidr
SUBNET=192.168.10.0/24

# The IP of the gateway. 
# Don't leave blank. Enter a valid ip from the subnet range
GATEWAY=192.168.10.254

# The amount of time in seconds tcpdump will create a new file
ROTATE_SECONDS=300

# Filters for specific traffic
# Examples:
# 'tcp and port 443'
# 'host 192.168.12.4'
# 'net 192.168.12.0/24'
# 'icmp'
# 'tcp src port 53'
# 'udp dst port 69'
# 'port not 443 and port not 80'
EXPRESSION=''

# Only enter one entry from the list below on the docker container
# Here is what tcpdump's manual has to say about this feature:
#
# Force packets selected by "expression" to be interpreted the specified type.
# Currently  known  types  are  
#   - aodv (Ad-hoc On-demand Distance Vector protocol),
#   - carp (Common Address Redundancy Protocol)
#   - cnfp (Cisco NetFlow  protocol),
#   - domain  (Domain Name System)
#   - lmp (Link Management Protocol)
#   - pgm (Pragmatic General Multicast)
#   - pgm_zmtp1 (ZMTP/1.0 inside PGM/EPGM)
#   - ptp (Precision Time Protocol)
#   - radius (RADIUS)
#   - resp (REdis Serialization Protocol)
#   - rpc (Remote Procedure Call)
#   - rtcp (Real-Time Applications control  protocol)
#   - rtp  (Real-Time Applications protocol)
#   - snmp  (Simple  Network  Management  Protocol)
#   - someip (SOME/IP)
#   - tftp (Trivial File Transfer  Protocol)
#   - vat  (Visual  Audio  Tool)
#   - vxlan (Virtual eXtensible Local Area Network)
#   - wb (distributed White Board)
#   - zmtp1 (ZeroMQ Message Transport Protocol 1.0).
EXPRESSION_TYPE=

# The ports for web management access of the docker container.
# ttyd tail, ttyd tmux, frontail, and tmux respectively
HTTPPORT1=8080
HTTPPORT2=8081
HTTPPORT3=8082
HTTPPORT4=8083

# The hostname of the instance of the docker container
HOSTNAME=tcpdump01
```


## Sample docker run script

```
#!/usr/bin/env bash
REPO=toddwint
APPNAME=tcpdump
HUID=$(id -u)
HGID=$(id -g)
SCRIPTDIR="$(dirname "$(realpath "$0")")"
source "$SCRIPTDIR"/config.txt

# Make the macvlan needed to listen on ports
# Set the IP on the host and add a route to the container
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
    ` # Volume can be changed to another folder. For Example: ` \
    ` # -v /home/"$USER"/Desktop/captures:/opt/"$APPNAME"/captures \ ` \
    -v "$SCRIPTDIR"/captures:/opt/"$APPNAME"/captures \
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
