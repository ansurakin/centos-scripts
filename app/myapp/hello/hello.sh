#!/bin/bash
#https://bloglisa.ru/?p=1225
echo $BASH_SOURCE "begin ..."

mkdir /opt/myapp
mkdir /opt/myapp/hello

yes | cp /var/lib/jenkins/workspace/hello/target/hello-*.jar /opt/myapp/hello/hello.jar
cd /opt/myapp/hello
java -jar hello.jar --server.port=8081

yes | cp -rf /opt/install/centos-scripts/app/myapp/hello.service /etc/systemd/system
systemctl daemon-reload
systemctl start hello
systemctl status hello
systemctl stop hello
systemctl enable hello

#firewall

echo $BASH_SOURCE "end"
