#!/bin/bash
# https://forum.vestacp.com/viewtopic.php?t=7481
# https://itdraft.ru/2018/06/07/ustanovka-postgresql-9-6-na-centos-7/
echo "postgresql begin ..."

cd /opt

yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm -y
yum install postgresql96-server phppgadmin -y
/usr/pgsql-9.6/bin/postgresql96-setup initdb
systemctl enable postgresql-9.6
systemctl start postgresql-9.6

sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|g" /var/lib/pgsql/9.6/data/postgresql.conf
sed -i "s|host    all             all             127.0.0.1/32            ident|host    all             all             0.0.0.0/0            md5|g" /var/lib/pgsql/9.6/data/pg_hba.conf
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '12345678';"
systemctl restart postgresql-9.6

#iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
#systemctl reload iptables

echo "postgresql end"
