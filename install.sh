#!/bin/bash

echo "���������� ��"
systemctl status firewalld
systemctl status iptables


#���������
cd /opt/centos-scripts

chmod +x ./first/first.sh
chmod +x ./app/postgresql.sh
chmod +x ./app/vesta.sh
chmod +x ./app/java.sh

./first/first.sh
./app/postgresql.sh
./app/vesta.sh
./app/java.sh


echo "���������� �����"
systemctl status firewalld
systemctl status iptables
