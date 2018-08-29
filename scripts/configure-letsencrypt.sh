#!/bin/bash
#
# This sets up Let's Encrypt SSL certificates and automatic renewal 
# using certbot: https://certbot.eff.org
#
# - Run this script as root.
# - A webserver must be up and running.
#
# Certificate files are placed into subdirectories under
# /etc/letsencrypt/live/*.
# 
# Configuration must then be updated for the systems using the 
# certificates.
#
# The certbot-auto program logs to /var/log/letsencrypt.
#
 
set -o nounset
set -o errexit

# Configure letsencrypt certificates
sudo mkdir -p /etc/letsencrypt
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/configs/letsencrypt/cli.ini -O /etc/letsencrypt/cli.ini
sudo sed -i "s/<domainName>/$1/g" /etc/letsencrypt/cli.ini
export HOME="/root"
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
sudo wget https://dl.eff.org/certbot-auto
sudo chmod a+x certbot-auto
sudo mv certbot-auto /usr/local/bin
sudo certbot-auto --noninteractive --os-packages-only
sudo certbot-auto certonly

# Diffie-Hellman parameter for DHE ciphersuites
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Configure letsencrypt renewal cron job
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/cron-jobs/certbot-renew.sh -O /etc/cron.daily/certbot-renew.sh
sudo chmod a+x /etc/cron.daily/certbot-renew.sh

# Change nginx config file for the domain
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/configs/nginx/config.ssl -O /etc/nginx/sites-available/$1
sudo sed -i "s/<domainName>/$1/g" /etc/nginx/sites-available/$1
sudo nginx -s reload
