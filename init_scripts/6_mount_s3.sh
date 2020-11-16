#!/bin/bash

echo "Mounting S3..."

EC2METALATEST=http://169.254.169.254/latest && \
EC2METAURL=$EC2METALATEST/meta-data/iam/security-credentials/ && \
EC2ROLE=`curl -s $EC2METAURL` && \
S3BUCKETNAME=bucket-for-terraform-test && \
DOC=`curl -s $EC2METALATEST/dynamic/instance-identity/document` && \
REGION=`jq -r .region <<< $DOC`

sudo /usr/local/bin/s3fs $S3BUCKETNAME \
-o use_cache=/tmp,iam_role="$EC2ROLE",allow_other /home/sftpuser/s3 \
-o url="https://s3-$REGION.amazonaws.com" \
-o nonempty

sudo chmod -R 777 /home/sftpuser/s3/*
