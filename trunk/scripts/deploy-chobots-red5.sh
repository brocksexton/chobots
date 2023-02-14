#!/bin/bash
DISTR=chobots
VERSION=$1
REPO="/var/www/$DISTR/red5_data/"
WEBAPPS="/usr/lib/red5/webapps"
RED5="/usr/lib/red5"


mkdir -p $REPO
scp -rq kavalok.com:/var/www/$DISTR/red5_data/$VERSION $REPO

echo "IS EVERYTHING COPIED OK ? IF YES - press enter, i will stop the server !!. IF NOT - CTRL+C"
read

/etc/init.d/red5 stop
cd /var/www/$DISTR/red5_data/$VERSION/webapps
rm -rf "$WEBAPPS/kavalok*"
cp -R $REPO/$VERSION/webapps/kavalok* "$WEBAPPS/"
cp -R $REPO/$VERSION/red5.jar "$RED5/"
perl -ne "s/{host.ip}/`hostname -i`/g;print" -i $WEBAPPS/kavalok*/WEB-INF/red5-web.properties
perl -ne "s/{host.ip}/`hostname -i`/g;print" -i $WEBAPPS/kavalok*/WEB-INF/classes/kavalok.properties
echo "IS THE DEPLOY READY ? IF YES - press enter. IF NOT - make it ready, and press enter"
read

/etc/init.d/red5 start
