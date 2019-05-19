#!/bin/bash

apt update
apt upgrade

apt install nginx -y

mkdir /var/cache/nginx

cd /etc/nginx

mv nginx.conf nginx.old
wget -L https://raw.githubusercontent.com/jblevins1991/NGINX-Configuration/master/WordPress/nginx/nginx.conf
chmod --reference=nginx.old nginx.conf
chown --reference=nginx.old nginx.conf

wget -L https://raw.githubusercontent.com/jblevins1991/NGINX-Configuration/master/WordPress/nginx/restrictions.conf
vagr
cd sites-enabled
wget -L https://raw.githubusercontent.com/jblevins1991/NGINX-Configuration/master/WordPress/nginx/wordpress

systemctl restart nginx

sudo apt install php-fpm -y

cd /etc/php/7.2/fpm

mv php-fpm.conf php-fpm.old
wget -L https://raw.githubusercontent.com/jblevins1991/NGINX-Configuration/master/WordPress/php/php-fpm.conf
chmod --reference=php-fpm.old php-fpm.conf
chown --reference=php-fpm.old php-fpm.conf

mv php.ini php.old
wget -L https://raw.githubusercontent.com/jblevins1991/NGINX-Configuration/master/WordPress/php/php.ini
chmod --reference=php.old php.ini
chown --reference=php.old php.ini

cd pool.d

wget -L https://raw.githubusercontent.com/jblevins1991/NGINX-Configuration/master/WordPress/php/pool.d/wp.conf
chmod --reference=www.conf wp.conf
chown --reference=www.conf wp.conf
rm www.conf

systemctl restart php7.2-fpm

sudo apt install mysql-server php-mysql -y

mysql_secure_installation <<EOF
n
password
password
y
y
y
y
y
EOF

systemctl restart mysql

sudo mysql --user=root --password=password <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER 'jblevins'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'pma'@'%' WITH GRANT OPTION;
EOF

systemctl restart mysql