CREATE DATABASE  IF NOT EXISTS cookbook;
CREATE USER IF NOT EXISTS '%USERNAME%'@'localhost' IDENTIFIED BY '%PASSWORD%';
GRANT ALL ON cookbook.* TO '%USERNAME%'@'localhost';