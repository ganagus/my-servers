CREATE DATABASE <dbName>;

CREATE USER <dbName>@'localhost' IDENTIFIED BY '<dbPassword>';
CREATE USER <dbName>@'%' IDENTIFIED BY '<dbPassword>';

GRANT ALL PRIVILEGES ON <dbName>.* TO <dbName>@'localhost';
GRANT ALL PRIVILEGES ON <dbName>.* TO <dbName>@'%';