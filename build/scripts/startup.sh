#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo $HOSTNAME > /etc/hostname

# Unzip frontail and tailon
gunzip /usr/local/bin/frontail.gz
gunzip /usr/local/bin/tailon.gz

# Create the user and group with host machine IDs
groupadd -g "$HGID" capturegroup
useradd -r -u "$HUID" -g "$HGID" captureuser
usermod -aG tcpdump captureuser

# Check if file exists and make the folder if not
# Checking for a file inside the folder because if the folder
#  is mounted as a volume it will already exists when docker starts.
# Also change permissions  
# --Leave the `.` after the source folder so it copies the contents (not folder)
if [ ! -e "/opt/$APPNAME/scripts/captures/.exists" ]
then
    mkdir -p /opt/"$APPNAME"/scripts/captures/
    touch /opt/"$APPNAME"/scripts/captures/.exists
    echo '`captures` folder create'
    chown -R "${HUID}":"${HGID}" /opt/"$APPNAME"/scripts/captures
fi

# Create logs folder and init files
mkdir -p /opt/"$APPNAME"/logs
touch /opt/"$APPNAME"/logs/"$APPNAME".log
truncate -s 0 /opt/"$APPNAME"/logs/"$APPNAME".log
echo "$(date -Is) [Start of $APPNAME log file]" >> /opt/"$APPNAME"/logs/"$APPNAME".log

# Start tcpdump
nohup /opt/"$APPNAME"/scripts/tcpdump.sh >> /opt/"$APPNAME"/logs/"$APPNAME".log 2>&1 &

# Start web interface
NLINES=1000
cp /opt/"$APPNAME"/scripts/tmux.conf /root/.tmux.conf
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tail.sh
# ttyd tail with color and read only
nohup ttyd -p "$HTTPPORT1" -R -t titleFixed="${APPNAME}|${APPNAME}.log" -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tail.sh >> /opt/"$APPNAME"/logs/ttyd1.log 2>&1 &
# ttyd tail without color and read only
#nohup ttyd -p "$HTTPPORT1" -R -t titleFixed="${APPNAME}|${APPNAME}.log" -T xterm-mono -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tail.sh >> /opt/"$APPNAME"/logs/ttyd1.log 2>&1 &
sed -Ei 's/tail -n 500/tail -n '"$NLINES"'/' /opt/"$APPNAME"/scripts/tmux.sh
# ttyd tmux with color
nohup ttyd -p "$HTTPPORT2" -t titleFixed="${APPNAME}|${APPNAME}.log" -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tmux.sh >> /opt/"$APPNAME"/logs/ttyd2.log 2>&1 &
# ttyd tmux without color
#nohup ttyd -p "$HTTPPORT2" -t titleFixed="${APPNAME}|${APPNAME}.log" -T xterm-mono -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tmux.sh >> /opt/"$APPNAME"/logs/ttyd2.log 2>&1 &
nohup frontail -n "$NLINES" -p "$HTTPPORT3" /opt/"$APPNAME"/logs/"$APPNAME".log >> /opt/"$APPNAME"/logs/frontail.log 2>&1 &
sed -Ei 's/\$lines/'"$NLINES"'/' /opt/"$APPNAME"/scripts/tailon.toml
sed -Ei '/^listen-addr = /c listen-addr = [":'"$HTTPPORT4"'"]' /opt/"$APPNAME"/scripts/tailon.toml
nohup tailon -c /opt/"$APPNAME"/scripts/tailon.toml /opt/"$APPNAME"/logs/"$APPNAME".log /opt/"$APPNAME"/logs/ttyd1.log /opt/"$APPNAME"/logs/ttyd2.log /opt/"$APPNAME"/logs/frontail.log /opt/"$APPNAME"/logs/tailon.log >> /opt/"$APPNAME"/logs/tailon.log 2>&1 &

# Keep docker running
bash
