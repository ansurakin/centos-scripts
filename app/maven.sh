#!/bin/bash
echo $BASH_SOURCE "begin ..."

wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
sudo mkdir /opt/maven
cd /opt/maven
sudo tar xzvf /tmp/apache-maven-*tar.gz -C /opt/maven --strip-components=1

sed -i -e '$a\export M2_HOME=/opt/maven' /etc/profile
sed -i -e '$a\export MAVEN_HOME=/opt/maven' /etc/profile
sed -i -e '$a\export PATH=$PATH:$M2_HOME/bin' /etc/profile
source /etc/profile
mvn -version

echo $BASH_SOURCE "end"
