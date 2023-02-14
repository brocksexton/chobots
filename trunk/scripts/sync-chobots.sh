#!/bin/bash
cd /var/www/html/
R=`. s3-bucket.sh $1`
if [[ $R != "" ]]; then
  echo $R
  exit 0;
fi

s3sync -p -r /var/www/html/game $S3_BUCKET_NAME:
s3sync -p -r $S3_BUCKET_NAME:game /var/www/html/

s3sync -r /usr/lib/red5/versions/ $S3_BUCKET_NAME:red5_data/ 
s3sync -r $S3_BUCKET_NAME:red5_data/ /usr/lib/red5/versions/

s3sync -p -r /var/www/html/javascripts $S3_BUCKET_NAME:
s3sync -p -r /var/www/html/stylesheets $S3_BUCKET_NAME:

