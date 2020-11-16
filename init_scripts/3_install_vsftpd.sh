#!/bin/bash

echo "3. Installing VSFTPD and OpenSSH Server..."
sudo yum -y install vsftpd
sudo yum -y install openssh-server

sudo mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

sudo mv /tmp/init_scripts/vsftpd.conf /etc/vsftpd/vsftpd.conf

sudo systemctl restart vsftpd.service