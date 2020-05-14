#!/bin/bash
#https://confluence.atlassian.com/adminjiraserver073/installing-jira-applications-on-linux-from-archive-file-861253033.html
#http://zetslash.blogspot.com/2017/04/ubuntu-jira-jira-62641-centosubuntu.html
#https://ealebed.github.io/posts/2017/установка-и-активация-jira-software-server-7.5.0/
#https://syncweb.ru/about/blog/ustanovka-i-nastrojka-confluence-na-sobstvennyj-server
echo $BASH_SOURCE "begin ..."

JIRA_INSTALLATION_DIR=/opt/jira
JIRA_HOME_DIR=/home/jira/application-data

#Создаем пользователя БД и саму БД
sudo -u postgres psql -U postgres -d postgres -c "CREATE ROLE jira WITH LOGIN PASSWORD '12345678' VALID UNTIL 'infinity';"
sudo -u postgres psql -U postgres -d postgres -c "CREATE DATABASE jira WITH ENCODING='UTF8' OWNER=jira;"

#create a user called jira:
sudo useradd --create-home --comment "Account for running JIRA Software" --shell /bin/bash jira
sudo passwd jira
#12345678

#extract zip to <installation-directory>
sudo mkdir $JIRA_INSTALLATION_DIR
cp /opt/install/atlassian-jira-software-*.tar.gz $JIRA_INSTALLATION_DIR
cd $JIRA_INSTALLATION_DIR
tar -zxf atlassian-jira-software-*.tar.gz && rm -f *.tar.gz && mv atlassian-jira-software-*/* $JIRA_INSTALLATION_DIR && rmdir atlassian-jira-software-*-standalone

#changing ownership of the installation directory and giving the user jira read, write and execute permissions.
chown -R jira $JIRA_INSTALLATION_DIR
chmod -R u=rwx,go-rwx $JIRA_INSTALLATION_DIR

sudo mkdir $JIRA_HOME_DIR
#changing ownership of the home directory and giving the user jira read, write and execute permissions.
chown -R jira $JIRA_HOME_DIR
chmod -R u=rwx,go-rwx $JIRA_HOME_DIR

#Установка переменных окружения
sed -i -e '$a\export JIRA_USER=jira' /etc/profile
sed -i -e '$a\export JIRA_HOME=/home/jira/application-data' /etc/profile
sed -i -e '$a\export JIRA_INSTALLATION_DIR=/opt/jira' /etc/profile

#Check the ports
sed -i 's|port="8005"|port="9005"|g' $JIRA_INSTALLATION_DIR/conf/server.xml
sed -i 's|port="8080"|port="9080"|g' $JIRA_INSTALLATION_DIR/conf/server.xml

#запуск
su jira
cd $JIRA_INSTALLATION_DIR/bin && ./start-jira.sh
#cd $JIRA_INSTALLATION_DIR/bin && ./stop-jira.sh

#Создаем скрипт для удобства запуска/остановки jira в командной строке
#https://confluence.atlassian.com/jirakb/start-jira-applications-automatically-in-linux-828796713.html
#https://confluence.atlassian.com/jirakb/run-jira-as-a-systemd-service-on-linux-979411854.html
yes | cp -rf /opt/install/jira/jira.service /lib/systemd/system
touch /lib/systemd/system/jira.service
chmod 664 /lib/systemd/system/jira.service
systemctl daemon-reload
systemctl enable jira.service
systemctl start jira.service
systemctl status jira.service

#firewall
#sudo iptables -A INPUT -p tcp --dport 9080 -j ACCEPT
#sudo iptables -A INPUT -p tcp --dport 9005 -j ACCEPT
echo $BASH_SOURCE "end"

#Замена файлов
#yes | cp -rf /opt/install/jira/atlassian-extras-*.jar $JIRA_INSTALLATION_DIR/atlassian-jira/WEB-INF/lib
#yes | cp -rf /opt/install/jira/atlassian-universal-plugin-manager-plugin-*.jar $JIRA_INSTALLATION_DIR/atlassian-jira/WEB-INF/atlassian-bundled-plugins

#Решение ошибок
#catalina.out
#Caused by: java.io.FileNotFoundException: /opt/jira/atlassian-jira/WEB-INF/lib/atlassian-extras-3.2.jar (Отказано в доступе)
#Задать права на файл, сменить пользователя

