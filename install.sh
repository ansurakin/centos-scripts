#!/bin/bash

#���������� ��
systemctl status firewalld
systemctl status iptables


#���������
cd /opt/centos-scripts

chmod +x ./first/first.sh
chmod +x ./app/postgresql.sh
chmod +x ./app/vesta.sh

./first/first.sh
./app/postgresql.sh
#./app/vesta.sh


#���������� �����
systemctl status firewalld
systemctl status iptables
