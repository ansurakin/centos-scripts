#!/bin/bash
echo "vesta begin ..."

cd /opt
curl -O http://vestacp.com/pub/vst-install.sh
bash vst-install.sh --nginx yes --apache yes --phpfpm no --named yes --remi yes --vsftpd yes --proftpd no --iptables yes --fail2ban yes --quota no --exim yes --dovecot yes --spamassassin yes --clamav yes --softaculous yes --mysql no --postgresql yes --hostname vesta.pgmaster.ru --email admin@pgmaster.ru --force
echo "vesta end"
