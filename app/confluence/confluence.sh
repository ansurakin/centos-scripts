#!/bin/bash
#https://ealebed.github.io/posts/2017/установка-и-активация-atlassian-confluence-6.3.4/
#https://syncweb.ru/about/blog/ustanovka-i-nastrojka-confluence-na-sobstvennyj-server
#https://confluence.atlassian.com/jirakb/run-jira-as-a-systemd-service-on-linux-979411854.html
#http://zetslash.blogspot.com/2017/04/ubuntu-jira-jira-62641-centosubuntu.html
echo $BASH_SOURCE "begin ..."

#version=7.4.0
CONFLUENCE_INSTALLATION_DIR=/opt/confluence
CONFLUENCE_HOME_DIR=/home/confluence/application-data

#Создаем пользователя БД и саму БД
sudo -u postgres psql -U postgres -d postgres -c "CREATE ROLE confluence WITH LOGIN PASSWORD '12345678' VALID UNTIL 'infinity';"
sudo -u postgres psql -U postgres -d postgres -c "CREATE DATABASE confluence WITH ENCODING='UTF8' OWNER=confluence;"

#create a user called confluence:
sudo useradd --create-home --comment "Account for running Confluence Software" --shell /bin/bash confluence
sudo passwd confluence
#12345678

#extract zip to <installation-directory>
sudo mkdir $CONFLUENCE_INSTALLATION_DIR
cp /opt/install/atlassian-confluence-*.tar.gz $CONFLUENCE_INSTALLATION_DIR
cd $CONFLUENCE_INSTALLATION_DIR
tar -zxf atlassian-confluence-*.tar.gz && rm -f *.tar.gz && mv atlassian-confluence-*/* $CONFLUENCE_INSTALLATION_DIR && rmdir atlassian-confluence-*

#changing ownership of the installation directory and giving the user confluence read, write and execute permissions.
chown -R confluence $CONFLUENCE_INSTALLATION_DIR
chmod -R u=rwx,go-rwx $CONFLUENCE_INSTALLATION_DIR

sudo mkdir $CONFLUENCE_HOME_DIR
#changing ownership of the home directory and giving the user confluence read, write and execute permissions.
chown -R confluence $CONFLUENCE_HOME_DIR
chmod -R u=rwx,go-rwx $CONFLUENCE_HOME_DIR

#Установка переменных окружения
#sed -i -e '$a\export CONFLUENCE_USER=confluence' /etc/profile
#sed -i -e '$a\export CONFLUENCE_HOME=/home/confluence/application-data' /etc/profile
#sed -i -e '$a\export CONFLUENCE_INSTALLATION_DIR=/opt/confluence' /etc/profile

#Check the ports
sed -i 's|port="8090"|port="9090"|g' $CONFLUENCE_INSTALLATION_DIR/conf/server.xml
#add the absolute path to your home directory
sed -i 's|# confluence.home=/var/confluence|confluence.home=/home/confluence/application-data|g' $CONFLUENCE_INSTALLATION_DIR/confluence/WEB-INF/classes/confluence-init.properties


#запуск
su confluence
cd $CONFLUENCE_INSTALLATION_DIR/bin && ./start-confluence.sh
#cd $CONFLUENCE_INSTALLATION_DIR/bin && ./stop-confluence.sh

#Создаем скрипт для удобства запуска/остановки confluence в командной строке
yes | cp -rf /opt/install/confluence/confluence.service /lib/systemd/system
touch /lib/systemd/system/confluence.service
chmod 664 /lib/systemd/system/confluence.service
systemctl daemon-reload
systemctl enable confluence.service
systemctl start confluence.service
systemctl status confluence.service

#firewall
#sudo iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
echo $BASH_SOURCE "end"

#Замена файлов
#yes | cp -rf /opt/install/confluence/atlassian-extras-*.jar $CONFLUENCE_INSTALLATION_DIR/atlassian-confluence/WEB-INF/lib
#yes | cp -rf /opt/install/confluence/atlassian-universal-plugin-manager-plugin-*.jar $CONFLUENCE_INSTALLATION_DIR/atlassian-confluence/WEB-INF/atlassian-bundled-plugins

#TODO безопасность + nginx https://syncweb.ru/about/blog/ustanovka-i-nastrojka-confluence-na-sobstvennyj-server