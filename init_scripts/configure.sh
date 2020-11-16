#!/bin/bash

echo "Configuring system"

sudo sh /tmp/init_scripts/1_update_and_install.sh
sudo sh /tmp/init_scripts/2_install_s3fs.sh
sudo sh /tmp/init_scripts/3_install_vsftpd.sh
sudo sh /tmp/init_scripts/4_configure_ssh.sh
sudo sh /tmp/init_scripts/5_create_sftp_user.sh
sudo sh /tmp/init_scripts/6_mount_s3.sh