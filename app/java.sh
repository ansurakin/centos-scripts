#!/bin/bash
#https://losst.ru/ustanovka-java-v-linux
#https://zalinux.ru/?p=254
echo "java begin ..."

#Предварительно нужно скопировать в папку /opt инсталяционный файл jdk
cd /opt

#распакуем
sudo mkdir java && tar -zxf jdk-*.tar.gz && rm *.tar.gz && mv jdk1.8.0_* java/jdk1.8.0

#Настрока переменных окружения
#Чтобы настройки были доступны для всех пользователей, будем использовать файл /etc/profile
sed -i -e '$a\export JAVA_HOME=/opt/java/jdk1.8.0' /etc/profile
sed -i -e '$a\export JRE_HOME=/opt/java/jdk1.8.0/jre' /etc/profile
sed -i -e '$a\export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' /etc/profile

source /etc/profile
java -version
echo "java end"
