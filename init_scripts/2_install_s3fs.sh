#!/bin/bash

echo "2. Downloading and installing S3FS Fuse..."
cd ~
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse

./autogen.sh
./configure

make
sudo make install