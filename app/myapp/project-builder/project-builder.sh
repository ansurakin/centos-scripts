#!/bin/bash
#https://bloglisa.ru/?p=1225
echo $BASH_SOURCE "begin ..."

mkdir /opt/myapp
mkdir /opt/myapp/project-builder

yes | cp /var/lib/jenkins/workspace/project-builder/target/project-builder-*.jar /opt/myapp/project-builder/project-builder.jar
cd /opt/myapp/project-builder
java -jar project-builder.jar --server.port=8082

yes | cp -rf /opt/install/centos-scripts/app/myapp/project-builder/project-builder.service /etc/systemd/system
systemctl daemon-reload
systemctl start project-builder
systemctl status project-builder
systemctl stop project-builder
systemctl enable project-builder

#firewall

echo $BASH_SOURCE "end"
