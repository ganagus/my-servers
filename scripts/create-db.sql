CREATE DATABASE wordpress;

CREATE USER wordpress@'localhost' IDENTIFIED BY '<dbuserpassword>';
CREATE USER wordpress@'%' IDENTIFIED BY '<dbuserpassword>';

GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@'localhost';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@'%';