CREATE DATABASE aprojectguru;

CREATE USER aprojectguru@'localhost' IDENTIFIED BY '<dbuserpassword>';
CREATE USER aprojectguru@'%' IDENTIFIED BY '<dbuserpassword>';

GRANT ALL PRIVILEGES ON aprojectguru.* TO aprojectguru@'localhost';
GRANT ALL PRIVILEGES ON aprojectguru.* TO aprojectguru@'%';