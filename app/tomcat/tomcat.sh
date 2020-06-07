#!/bin/bash
#https://www.hostinger.ru/rukovodstva/ustanovka-tomcat-v-ubuntu
echo $BASH_SOURCE "begin ..."

sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.35/bin/apache-tomcat-9.0.35.tar.gz
sudo mkdir /opt/tomcat
cd /opt/tomcat
sudo tar xzvf /tmp/apache-tomcat-9.0.*tar.gz -C /opt/tomcat --strip-components=1
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/

yes | cp -rf /opt/install/tomcat/tomcat.service /etc/systemd/system
systemctl daemon-reload
systemctl enable tomcat.service
systemctl start tomcat.service
systemctl status tomcat.service

sed -i -e '$a\export CATALINA_HOME=/opt/tomcat' /etc/profile
source /etc/profile

sudo mcedit /opt/tomcat/conf/tomcat-users.xml
#<user username="admin" password="password" roles="manager-gui,admin-gui"/>
sudo mcedit /opt/tomcat/webapps/manager/META-INF/context.xml
sudo mcedit /opt/tomcat/webapps/host-manager/META-INF/context.xml
#<!--
#  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
#         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
#-->

echo $BASH_SOURCE "end"

#Следующие команды позволят вам выполнить сервис Tomcat:
#cd /opt/tomcat/bin
#sudo ./startup.sh run
