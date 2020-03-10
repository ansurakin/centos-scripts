#!/bin/bash
echo "first begin ..."

#идем в директорию /etc/sysconfig/network-scripts и открываем на редактирование файл ifcfg-eth0
#DNS1="217.10.32.4"
#systemctl restart network

#https://serveradmin.ru/centos-nastroyka-servera/
#https://serveradmin.ru/nastroyka-seti-v-centos/

yum install epel-release -y
yum update -y

yum install wget -y
yum install mc -y
yum install net-tools -y
yum install bind-utils -y

echo "first end"
