#!/bin/bash
DISTR=chobots
VERSION=$1
mkdir -p /var/www/$DISTR
cd /var/www/$DISTR
scp -rq kavalok.com:/var/www/$DISTR/game/$VERSION game/
S3_BUCKET_NAME='alpha-static'
s3sync -p -r game $S3_BUCKET_NAME:
s3sync -p -r game/$VERSION/ $S3_BUCKET_NAME:game/
echo "IS THE DEPLOY READY ?"
read
deploy-chobots-local.sh $VERSION
