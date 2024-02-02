#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo systemctl enable --now httpd
sudo chown -R ec2-user:ec2-user /var/www/html/
sudo echo '<h1>hello from terraform</h1>' > /var/www/html/index.html