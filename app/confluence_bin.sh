#!/bin/bash

echo $BASH_SOURCE "begin ..."

#Создаем пользователя БД и саму БД
sudo -u postgres psql -U postgres -d postgres -c "CREATE ROLE confluence WITH LOGIN PASSWORD '12345678' VALID UNTIL 'infinity';"
sudo -u postgres psql -U postgres -d postgres -c "CREATE DATABASE confluence WITH ENCODING='UTF8' OWNER=confluence;"

sudo iptables -A INPUT -p tcp --dport 8090 -j ACCEPT

cd /opt && chmod a+x atlassian-confluence-7.3.3-x64.bin
sudo ./atlassian-confluence-7.3.3-x64.bin

echo $BASH_SOURCE "end"
