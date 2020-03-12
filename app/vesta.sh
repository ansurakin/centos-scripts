#!/bin/bash
#https://forum.vestacp.com/viewtopic.php?t=7481
echo "vesta begin ..."

cd /opt
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh --nginx yes --phpfpm yes --apache no --named yes --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim no --dovecot no --spamassassin no --clamav no --softaculous no --mysql no --postgresql no --hostname pgmaster.ru --email sanringo@mail.ru --password 12345678

#TODO доработать. Тут не выполняется
echo "test111"
export VESTA=/usr/local/vesta
sed -i -e '$a\DB_SYSTEM=\x27mysql,pgsql\x27' $VESTA/conf/vesta.conf#TODO дублирует?
sed -i "s|service='postgresql'|service='postgresql-9.6'|g" $VESTA/bin/v-list-sys-services
#Регистрируем базу в панели
$VESTA/bin/v-add-database-host pgsql 127.0.0.1 postgres 12345678#Нужно ли тут?
#service apache2 restart

echo "vesta end"
