#!/bin/bash
echo "settings begin ..."

# ��������� selinux
sed -i 's|SELINUX=enforcing|SELINUX=disabled|' /etc/selinux/config

echo "settings end"
