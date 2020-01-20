#!/bin/bash
#�������� firewalld �� iptables:
systemctl disable firewalld
systemctl stop firewalld
yum install iptables-services -y
systemctl start iptables
systemctl start ip6tables
#���������� ��� ���������:
systemctl enable iptables
systemctl enable ip6tables
#��� ���������� ������ iptables ����� ������������:
/sbin/iptables-save > /etc/sysconfig/iptables
/sbin/ip6tables-save > /etc/sysconfig/ip6tables
#������� ������� ��������� � ������: /etc/sysconfig/iptables /etc/sysconfig/ip6tables
#���������� iptables (��������, ����� ���������� �����-���� ���������):
# systemctl restart iptables