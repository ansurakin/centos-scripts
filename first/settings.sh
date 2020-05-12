#!/bin/bash
echo "settings begin ..."

# выключаем selinux
sed -i 's|SELINUX=enforcing|SELINUX=disabled|' /etc/selinux/config

echo "settings end"
