#!/bin/bash

sudo apt-get update

# Donwload wordpress from wordpress.org, and copy it to /var/www/<domainName>
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mkdir -p /var/www/$1
sudo cp -R wordpress/* /var/www/$1/
sudo chown -R www-data:www-data /var/www/$1/

# Install nginx
sudo apt-get install -y nginx
sudo apt-get install -y php-fpm php-mysql
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini
sudo service nginx start
sudo systemctl restart php7.0-fpm
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
sudo chown www-data:www-data /var/www/$1/wp-config.php
sudo rm /var/www/$1/wp-config-sample.php

# Configure letsencrypt certificates
sudo mkdir /etc/letsencrypt
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/configs/letsencrypt/cli.ini -O /etc/letsencrypt/cli.ini
sudo sed -i "s/<domainName>/$1/g" /etc/letsencrypt/cli.ini
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
sudo wget https://dl.eff.org/certbot-auto
sudo chmod a+x certbot-auto
sudo mv certbot-auto /usr/local/bin
sudo certbot-auto --noninteractive --os-packages-only
sudo certbot-auto certonly

# Configure letsencrypt renewal cron job
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/cron-jobs/certbot-renew.sh -O /etc/cron.daily/certbot-renew.sh
sudo chmod a+x /etc/cron.daily/certbot-renew.sh

# Install dotnet core
#wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
#sudo dpkg -i packages-microsoft-prod.deb
#sudo apt-get install apt-transport-https
#sudo apt-get update
#sudo apt-get install dotnet-sdk-2.1.4 -y