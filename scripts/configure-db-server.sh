#!/bin/bash

sudo apt-get update

# Configure mysql-server
export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"
sudo apt-get install -y mysql-server
sudo sed -i "s/= 127.0.0.1/= 0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

# Create wordpress database
sudo wget https://raw.githubusercontent.com/ganagus/my-servers/master/scripts/create-db.sql
sudo sed -i "s/<dbName>/$2/g" create-db.sql
sudo sed -i "s/<dbPassword>/$3/g" create-db.sql
sudo mysql -u"root" -p"$1" < create-db.sql

# Install mongodb from mongodb-org
# wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
# echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
# sudo apt-get update
# sudo apt-get install -y mongodb-org
# sudo systemctl start mongod
# sudo systemctl enable mongod
# add frontendIPAddress to list of allowed IPs
#sudo sed -i "s/bind_ip = 127.0.0.1/bind_ip = 127.0.0.1,$4/g" /etc/mongod.conf