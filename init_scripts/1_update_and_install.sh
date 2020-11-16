#!/bin/bash

echo "1. Updating and installing libraries..."
sudo yum -y update && \
sudo yum -y install \
jq \
automake \
openssl-devel \
git \
gcc \
libstdc++-devel \
gcc-c++ \
fuse \
fuse-devel \
curl-devel \
libxml2-devel