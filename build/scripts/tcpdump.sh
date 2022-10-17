if [ -z "$EXPRESSION_TYPE" ] && [ -z "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z captureuser -w /opt/"$APPNAME"/scripts/captures/tcpdumptimedcap-%FT%T%z.pcap -G $ROTATE_SECONDS --print port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4"
elif [ -z "$EXPRESSION_TYPE" ] && [ -n "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z captureuser -w /opt/"$APPNAME"/scripts/captures/tcpdumptimedcap-%FT%T%z.pcap -G $ROTATE_SECONDS --print port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4" and "$EXPRESSION"
elif [ -n "$EXPRESSION_TYPE" ] && [ -z "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z captureuser -w /opt/"$APPNAME"/scripts/captures/tcpdumptimedcap-%FT%T%z.pcap -G $ROTATE_SECONDS --print -T "$EXPRESSION_TYPE" port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4"
elif [ -n "$EXPRESSION_TYPE" ] && [ -n "$EXPRESSION" ]; then
    tcpdump -i eth0 -env --number -U -Z captureuser -w /opt/"$APPNAME"/scripts/captures/tcpdumptimedcap-%FT%T%z.pcap -G $ROTATE_SECONDS --print -T "$EXPRESSION_TYPE" port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4" and "$EXPRESSION"
else
    tcpdump -i eth0 -env --number -U -Z captureuser -w /opt/"$APPNAME"/scripts/captures/tcpdumptimedcap-%FT%T%z.pcap -G $ROTATE_SECONDS --print port not "$HTTPPORT1" and port not "$HTTPPORT2" and port not "$HTTPPORT3" and port not "$HTTPPORT4"
fi
