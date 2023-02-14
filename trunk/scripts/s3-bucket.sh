#!/bin/bash

DISTR=$1
if [[ $DISTR = "kavalok" ]]; then
  export S3_BUCKET_NAME='kavalok-static'
elif [[ $DISTR = "chobots" ]]; then
  export S3_BUCKET_NAME='chobots-static'
else
  echo "usage $0 (kavalog|chobots)"
  exit 0 
fi
