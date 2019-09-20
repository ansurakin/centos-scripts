#!/bin/bash
echo "first begin ..."

cd /opt
yum install epel-release -y
yum update -y

yum install wget -y

echo "first end"
