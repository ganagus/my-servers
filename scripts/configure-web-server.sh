#!/bin/bash

sudo apt-get update

# Donwload wordpress from wordpress.org, and copy it to /var/www/wordpress
sudo wget https://wordpress.org/wordpress-4.9.8.tar.gz
sudo tar -xvzf wordpress-4.9.8.tar.gz
sudo mkdir -p /var/www/wordpress
sudo cp -R wordpress/* /var/www/wordpress/
sudo chown -R www-data:www-data /var/www/wordpress/

# Install nginx
sudo apt-get install -y nginx
sudo apt-get install -y php-fpm php-mysql
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini
sudo service nginx start
sudo systemctl restart php7.0-fpm
sudo wget https://raw.githubusercontent.com/icgid/poc-iaac-azure-linux-script/master/configs/nginx/wordpress -O /etc/nginx/sites-available/wordpress
sudo sed -i "s/<wordpressDomainName>/$1/g" /etc/nginx/sites-available/wordpress
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Upload existing wordpress configuration file
sudo wget https://raw.githubusercontent.com/icgid/poc-iaac-azure-linux-script/master/configs/wordpress/wp-config.php -O /var/www/wordpress/wp-config.php
sudo sed -i "s/<dbUserPassword>/$2/g" /var/www/wordpress/wp-config.php
sudo sed -i "s/<backendIPAddress>/$3/g" /var/www/wordpress/wp-config.php
sudo chown www-data:www-data /var/www/wordpress/wp-config.php

# Install dotnet core
#wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
#sudo dpkg -i packages-microsoft-prod.deb
#sudo apt-get install apt-transport-https
#sudo apt-get update
#sudo apt-get install dotnet-sdk-2.1.4 -y