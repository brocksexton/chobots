#!/bin/bash
LINES=4000
TAIL=6000
NAME="stacktraces/`date +%Y%m%d_%H%M%S`.log"
cd /usr/lib/red5/log
cat /var/run/red5.pid | xargs kill -QUIT
sleep 1
tail -n $TAIL std.log | grep "Full thread dump Java" -A $LINES| grep "PSPermGen" -A1 -B$LINES > $NAME
echo "`pwd`/$NAME"

