#!/bin/bash
echo "vesta begin ..."

cd /opt
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh --nginx yes --phpfpm yes --apache no --named yes --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim no --dovecot no --spamassassin no --clamav no --softaculous yes --mysql no --postgresql no --hostname pgmaster.ru --email sanringo@mail.ru --password 12345678

sed -i -e '$a\DB_SYSTEM=\x27mysql,pgsql\x27' /usr/local/vesta/conf/vesta.conf
sed -i "s|service='postgresql'|service='postgresql-9.6'|g" /usr/local/vesta/bin/v-list-sys-services
#Регистрируем базу в панели
export VESTA=/usr/local/vesta/
#$VESTA/bin/v-add-database-host pgsql 127.0.0.1 postgres 12345678
#service apache2 restart

echo "vesta end"
