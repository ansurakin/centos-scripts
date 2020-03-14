#!/bin/bash
#https://gist.github.com/foi/68337d38c628b286d0f3811ca76aa815
#https://itdraft.ru/2019/12/10/ustanovka-redmine-4-0-5-nginx-postgresql-v-centos-7/
echo "redmine begin ..."

# �������� ������ redmine, ���� ����� / change redmine version number if need
REDMINE_VERSION="4.0.5"
# ���������� ���� ��� redmine / set redmine language
REDMINE_LANGUAGE="ru"
# ������������� rpm ����� � ruby 
cd /tmp && wget https://github.com/feedforce/ruby-rpm/releases/download/2.7.0/ruby-2.7.0-1.el7.centos.x86_64.rpm
yum install -y ruby-2.7.0-1.el7.centos.x86_64.rpm
gem install bundler
# ������ redmine / Download redmine 
wget http://www.redmine.org/releases/redmine-$REDMINE_VERSION.tar.gz
tar -xf redmine-$REDMINE_VERSION.tar.gz 
mv redmine-$REDMINE_VERSION /opt/redmine
cd /opt/redmine
# ��������� ���������� ���-������ puma / we'll use puma because webrick is sucks
echo 'gem "puma"' > Gemfile.local

#������� ������������ �� � ���� ��
sudo -u postgres psql -U postgres -d postgres -c "create user redmine;"
sudo -u postgres psql -U postgres -d postgres -c "alter user redmine with password '12345678';"
sudo -u postgres psql -U postgres -d postgres -c "CREATE DATABASE redmine WITH ENCODING='UTF8' OWNER=redmine;"

cat > config/database.yml << EOL
production:
  adapter: postgresql
  database: redmine
  host: localhost
  username: redmine
  password: 12345678
EOL
# ������������� ����������� 
yum groupinstall -y "Development tools"
yum install -y ImageMagick ImageMagick-devel
yum install -y sqlite sqlite-devel
bundle install --without development test
# ���������� ����� ��� ������ 
bundle exec rake generate_secret_token
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production REDMINE_LANG=$REDMINE_LANGUAGE bundle exec rake redmine:load_default_data
# ��������� 80 ���� ��� ���-������� / open 80 port for web-server
#firewall-cmd --permanent --add-service=http
#firewall-cmd --reload
# ��������� smtp / SMTP config - http://www.redmine.org/projects/redmine/wiki/EmailConfiguration#GMail-Google-Apps
cp config/configuration.yml.example config/configuration.yml
# ���������� �������� ����� � ���������� / basic smtp config
sed -i 's/  email_delivery:/  email_delivery:\n    delivery_method: :async_smtp\n    smtp_settings:\n      address: "localhost"\n      port: 25/' config/configuration.yml 
# ������� ������������ ��� ���-������� puma / Make puma web-server config
cat > /opt/redmine/puma_config.rb << EOL
#!/usr/bin/env puma
directory '/opt/redmine'
daemonize true
pidfile '/run/puma.pid'
stdout_redirect '/opt/redmine/log/log.out', '/opt/redmine/log/log.error', true
environment 'production'
bind 'tcp://0.0.0.0:80'
EOL

# ������� systemd service-���� redmine ��� ����������� / Make systemd service file for autostart redmine
cat > /etc/systemd/system/redmine.service << EOL
[Unit]
Description=Redmine on Puma web-server
After=network.target

[Service]
Type=forking
User=root
WorkingDirectory=/opt/redmine
PIDFile=/run/puma.pid
ExecStart=/usr/bin/bundle exec puma -C /opt/redmine/puma_config.rb
ExecStop=/bin/kill -9 $MAINPID
TimeoutSec=60

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable redmine
systemctl start redmine
systemctl status redmine

echo "redmine end"
