HUID=$(id --user "$APPNAME" 2> /dev/null || id --user root)
HGID=$(id --group "$APPNAME" 2> /dev/null || id --group root)
user=$(id --user --name $HUID)

# strftime %FT%H-%M-%S%z examples: 2022-11-19T15-57-46-0600 and 2022-11-20T05-59-20+0800
if [ -z "$EXPRESSION_TYPE" ] && [ -z "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z "$user" -w /opt/"$APPNAME"/captures/tcpdumptimedcap-%FT%H-%M-%S%z.pcap -G $ROTATE_SECONDS --print port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4"
elif [ -z "$EXPRESSION_TYPE" ] && [ -n "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z "$user" -w /opt/"$APPNAME"/captures/tcpdumptimedcap-%FT%H-%M-%S%z.pcap -G $ROTATE_SECONDS --print port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4" and "(${EXPRESSION})"
elif [ -n "$EXPRESSION_TYPE" ] && [ -z "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z "$user" -w /opt/"$APPNAME"/captures/tcpdumptimedcap-%FT%H-%M-%S%z.pcap -G $ROTATE_SECONDS --print -T "$EXPRESSION_TYPE" port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4"
elif [ -n "$EXPRESSION_TYPE" ] && [ -n "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z "$user" -w /opt/"$APPNAME"/captures/tcpdumptimedcap-%FT%H-%M-%S%z.pcap -G $ROTATE_SECONDS --print -T "$EXPRESSION_TYPE" port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4" and "(${EXPRESSION})"
else
    tcpdump -i eth0 -env --number -U -Z "$user" -w /opt/"$APPNAME"/captures/tcpdumptimedcap-%FT%H-%M-%S%z.pcap -G $ROTATE_SECONDS --print port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4"
fi
