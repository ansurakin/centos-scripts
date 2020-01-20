#!/bin/bash
#заменить firewalld на iptables:
systemctl disable firewalld
systemctl stop firewalld
yum install iptables-services -y
systemctl start iptables
systemctl start ip6tables
#Автозапуск при включении:
systemctl enable iptables
systemctl enable ip6tables
#Для сохранения правил iptables после перезагрузки:
/sbin/iptables-save > /etc/sysconfig/iptables
/sbin/ip6tables-save > /etc/sysconfig/ip6tables
#Текущие правила находятся в файлах: /etc/sysconfig/iptables /etc/sysconfig/ip6tables
#Перезапуск iptables (например, после совершения каких-либо изменений):
# systemctl restart iptables