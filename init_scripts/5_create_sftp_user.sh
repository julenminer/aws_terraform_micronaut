#!/bin/bash

echo "Creating SFTP user..."

sudo groupadd sftp
sudo useradd -m sftpuser -s /sbin/nologin -g sftp
sudo echo "<PASSWORD>" | passwd sftpuser --stdin

sudo chown root /home/sftpuser
sudo chmod 755 /home/sftpuser
sudo mkdir /home/sftpuser/s3
sudo chown sftpuser:sftp /home/sftpuser/s3
