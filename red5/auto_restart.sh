#!/bin/bash
cd /usr/lib/red5/log
LINE1="`tail -1 kavalok.log | awk '{print $1}'`"
sleep 5
LINE2="`tail -1 kavalok.log | awk '{print $1}'`"

if [ "$LINE1" == "$LINE2" ]; then
  /etc/init.d/red5 restart
fi
