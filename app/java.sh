#!/bin/bash
#https://losst.ru/ustanovka-java-v-linux
#https://zalinux.ru/?p=254
echo "java begin ..."

#�������������� ����� ����������� � ����� /opt �������������� ���� jdk
cd /opt

#���������
sudo mkdir java && tar -zxf jdk-*.tar.gz && rm *.tar.gz && mv jdk1.8.0_* java/jdk1.8.0

#�������� ���������� ���������
#����� ��������� ���� �������� ��� ���� �������������, ����� ������������ ���� /etc/profile
sed -i -e '$a\export JAVA_HOME=/opt/java/jdk1.8.0' /etc/profile
sed -i -e '$a\export JRE_HOME=/opt/java/jdk1.8.0/jre' /etc/profile
sed -i -e '$a\export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' /etc/profile

source /etc/profile
java -version
echo "java end"
