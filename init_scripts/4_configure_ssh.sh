#!/bin/bash

echo "Configuring SSH..."
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo mv /tmp/init_scripts/sshd_config /etc/ssh/sshd_config

sudo systemctl restart sshd