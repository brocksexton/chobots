#!/bin/bash
VERSION=$1

cd /var/www/javascripts/
perl -ne "s/var ch_version = .*?;/var ch_version = '$VERSION';/g;print" -i /var/www/javascripts/game.js 
#cd /var/www/
#perl -ne "s/\/game\/.*?\//\/game\/$VERSION\//g;print" -i .htaccess

cd /var/www/game
rm Main.swf
ln -s "$VERSION/Main.swf"
rm MainLoader.swf
ln -s "$VERSION/MainLoader.swf"
rm MainAgent.swf
ln -s "$VERSION/MainAgent.swf"
rm MainLoaderFullScreen.swf
ln -s "$VERSION/MainLoaderFullScreen.swf"
rm CharWidget.swf
ln -s "$VERSION/CharWidget.swf"
rm ChickingZoner8BLank.swf
ln -s "$VERSION/ChickingZoner8BLank.swf"
cd /var/www/game
rm resources
ln -s "$VERSION/resources"

cd /var/www/
chmod 0777 "game/$VERSION" -R
rm resources
ln -s "game/$VERSION/resources"
rm magic
ln -s "game/$VERSION/resources/magic"

#cd /var/www/staff/admin/moderators
#rm SpeakOfTheChobotDevilServiceAgent3.swf
#ln -s "/var/www/game/$VERSION/SpeakOfTheChobotDevilServiceAgent3.swf"
#rm resources
#ln -s "/var/www/game/$VERSION/resources"

echo "Soft link creation complete. The game version is $VERSION"
