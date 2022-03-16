#!/bin/bash

# install nginx
sudo yum update -y
sudo amazon-linux-extras list | grep nginx
sudo yum clean metadata -y
sudo yum -y install nginx -y
sudo amazon-linux-extras install nginx1 -y

# make sure nginx is started
sudo systemctl start nginx
