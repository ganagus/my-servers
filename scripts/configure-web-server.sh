#!/bin/bash

sudo apt-get update

# Donwload wordpress from wordpress.org, and copy it to /var/www/<domainName>
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mkdir -p /var/www/$1
sudo cp -R wordpress/* /var/www/$1/
sudo chown -R $5:www-data /var/www/$1/
sudo find /var/www/$1 -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/$1/wp-content
sudo chmod -R g+w /var/www/$1/wp-content/themes
sudo chmod -R g+w /var/www/$1/wp-content/plugins

# Install nginx
sudo apt-get install -y nginx

# Install PHP 7.3
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.3 php7.3-fpm php7.3-mysql php7.3-cli
sudo apt-get install -y php7.3-curl php7.3-gd php7.3-mbstring php7.3-xml php7.3-xmlrpc php7.3-zip
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.3/fpm/php.ini
sudo service nginx start
sudo systemctl restart php7.3-fpm
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/configs/nginx/config -O /etc/nginx/sites-available/$1
sudo sed -i "s/<domainName>/$1/g" /etc/nginx/sites-available/$1
sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Upload existing wordpress configuration file
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/configs/wordpress/wp-config.php -O /var/www/$1/wp-config.php
sudo sed -i "s/<dbName>/$2/g" /var/www/$1/wp-config.php
sudo sed -i "s/<dbPassword>/$3/g" /var/www/$1/wp-config.php
sudo sed -i "s/<backendIPAddress>/$4/g" /var/www/$1/wp-config.php
wordpressSecretKeys="`sudo wget -qO- https://api.wordpress.org/secret-key/1.1/salt/`"
sudo wget https://raw.githubusercontent.com/ganagus/Linux-str_replace/master/str_replace.pl -O /usr/local/bin/str_replace
sudo chmod a+x /usr/local/bin/str_replace
sudo str_replace "<wordpressSecretKeys>" "$wordpressSecretKeys" /var/www/$1/wp-config.php
sudo chown $5:www-data /var/www/$1/wp-config.php
sudo rm /var/www/$1/wp-config-sample.php

# Copy configure-letsencrypt.sh to /root
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/scripts/configure-letsencrypt.sh -O /root/configure-letsencrypt.sh
sudo chmod a+x /root/configure-letsencrypt.sh

# After provisioning, configure SSL by running the following commands:
# sudo su
# /root/configure-letsencrypt.sh <domain-name>
#
# Then use the config.ssl for the virtual host

# Installing nodejs and npm
sudo apt install -y nodejs
sudo apt install -y npm

# Install dotnet core
#wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
#sudo dpkg -i packages-microsoft-prod.deb
#sudo apt-get install apt-transport-https
#sudo apt-get update
#sudo apt-get install dotnet-sdk-2.1.4 -y