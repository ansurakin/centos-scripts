#!/bin/bash
#https://kamaok.org.ua/?p=2722
echo $BASH_SOURCE "begin ..."

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
#sudo yum upgrade
sudo yum install -y jenkins

sed -i 's|JENKINS_PORT="8080"|JENKINS_PORT="9081"|g' /etc/sysconfig/jenkins
#Добавить в /etc/init.d/jenkins путь к java /opt/java/jdk1.8.0/bin/java
sudo systemctl daemon-reload

systemctl start jenkins
systemctl enable jenkins

#Продолжаем установку через WEB-интерфейс
#http://<Jenkins-server-IP-address>:9081
#Пароль указан в файле
cat /var/lib/jenkins/secrets/initialAdminPassword
#Просмотр логов Jenkins
#tail -f /var/log/jenkins/jenkins.log

echo $BASH_SOURCE "end"
