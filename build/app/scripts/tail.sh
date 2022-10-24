#!/usr/bin/env bash
echo '
  Welcome to the '"$APPNAME"' docker image.

  Captures will be saved to the `captures` volume specified in the 
  docker run command.
'
sleep 1s
tail -n 500 -F /opt/"$APPNAME"/logs/"$APPNAME".log
