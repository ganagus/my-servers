#!/bin/bash

sudo apt-get update

# Donwload wordpress from wordpress.org, and copy it to /var/www/aprojectguru
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mkdir -p /var/www/aprojectguru
sudo cp -R wordpress/* /var/www/aprojectguru/
sudo chown -R www-data:www-data /var/www/aprojectguru/

# Install nginx
sudo apt-get install -y nginx
sudo apt-get install -y php-fpm php-mysql
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini
sudo service nginx start
sudo systemctl restart php7.0-fpm
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/configs/nginx/aprojectguru -O /etc/nginx/sites-available/wordpress
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Upload existing wordpress configuration file
sudo wget https://raw.githubusercontent.com/icgid/poc-iaac-azure-linux-script/master/configs/wordpress/wp-config.php -O /var/www/aprojectguru/wp-config.php
sudo sed -i "s/<dbUserPassword>/$1/g" /var/www/aprojectguru/wp-config.php
sudo sed -i "s/<backendIPAddress>/$2/g" /var/www/aprojectguru/wp-config.php
wordpressSecretKeys="`sudo wget -qO- https://api.wordpress.org/secret-key/1.1/salt/`"
sudo wget https://raw.githubusercontent.com/ganagus/Linux-str_replace/master/str_replace.pl -O /usr/local/bin/str_replace
sudo chmod a+x /usr/local/bin/str_replace
sudo str_replace "<wordpressSecretKeys>" "$wordpressSecretKeys" /var/www/aprojectguru/wp-config.php
sudo chown www-data:www-data /var/www/aprojectguru/wp-config.php

# Install dotnet core
#wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
#sudo dpkg -i packages-microsoft-prod.deb
#sudo apt-get install apt-transport-https
#sudo apt-get update
#sudo apt-get install dotnet-sdk-2.1.4 -y