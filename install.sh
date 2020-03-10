#!/bin/bash

cd /opt/centos-scripts

chmod +x ./install.sh
chmod +x ./first/first.sh
chmod +x ./app/postgresql.sh
chmod +x ./app/vesta.sh


./first/first.sh
./app/postgresql.sh
./app/vesta.sh
