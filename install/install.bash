#!/bin/bash

# RMS Setup Script
#
# Author: Russell Toris - rctoris@wpi.edu

DB="rms"
USER="rms"

echo " ____  __  __ ____  "
echo "|  _ \|  \/  / ___| "
echo "| |_) | |\/| \___ \ "
echo "|  _ <| |  | |___) |"
echo "|_| \_\_|  |_|____/ "
echo

echo
echo "Robot Management System Setup"
echo "Author: Russell Toris - rctoris@wpi.edu"
echo

# check the directory we are working in
DIR=`pwd`
if [[ $DIR != *install ]]
then
	echo "ERROR: Please run this script in the 'install' directory."
	exit;
fi

echo
echo "WARNING: This is an automated setup script."
echo "It will create a fresh install of the RMS."
echo "Any older versions of RMS will be deleted."
echo

# confirmation prompt
while true; do
	read -p "Continue with installation? [Y/n] " yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer with 'y' or 'n'";;
	esac
done

## Update and install the LAMP server
echo
echo "Setting up LAMP, PhpMyAdmin, and PEAR..."
echo -e "\tupdating sources..."
sudo apt-get update >> /dev/null
echo -e "\tinstalling LAMP..."
sudo apt-get install lamp-server^ -yy >> /dev/null
echo -e "\tinstalling PhpMyAdmin and PEAR..."
sudo apt-get install phpmyadmin php-pear >> /dev/null
echo -e "\tenabling Apache mod-rewrite..."
sudo a2enmod rewrite >> /dev/null
sudo service apache2 restart > /dev/null 2>&1

## Setup CakePHP
echo
echo "Setting up CakePHP..."
echo -e "\tadding CakePHP channel to PEAR..."
sudo pear channel-discover pear.cakephp.org >> /dev/null
echo -e "\tinstalling CakePHP via PEAR..."
sudo pear install cakephp/CakePHP-2.4.9 >> /dev/null

## Install the app
echo
echo "Linking RMS to Apache..."
echo -e "\tinstalling site configuration..."
sudo cp rms.conf /etc/apache2/sites-available/
echo -e "\tdisabling default Apache site(s)..."
sudo a2dissite 000-default.conf > /dev/null 2>&1
sudo a2dissite rms.conf > /dev/null 2>&1
echo -e "\tlinking RMS folder to Apache..."
sudo rm -f /var/www/rms
sudo ln -s $DIR/../app/ /var/www/rms
echo -e "\trestarting Apache..."
sudo a2ensite rms.conf > /dev/null
sudo /etc/init.d/apache2 restart > /dev/null 2>&1

## Create a tmp folder
echo
echo "Setting up site tmp folder..."
mkdir -p ../app/tmp
sudo chown -R www-data ../app/tmp

## Setup the SQL server
echo
echo "Setting MySQL server (use SQL root password)..."
echo -e "\tgenerating random password..."
PASS=`date +%s | sha256sum | base64 | head -c 16 ;`
echo -e "\tcreating RMS database and local MySQL user..."
mysql -u root -v -e "DROP DATABASE IF EXISTS $DB; \
GRANT USAGE ON *.* TO '$USER'@'localhost'; \
DROP USER '$USER'@'localhost'; \
CREATE DATABASE IF NOT EXISTS $DB; \
GRANT ALL PRIVILEGES ON $DB.* TO '$USER'@'localhost' IDENTIFIED BY '$PASS';\G " -p  >> /dev/null
echo -e "\tinstalling the RMS database..."
mysql -D $DB -u $USER -p$PASS < rms.sql

## Setup the CakePHP configuration
echo
echo "Setting CakePHP configuration file(s)..."
CONFIG="<?php\n
// auto generated by RMS setup \n
class DATABASE_CONFIG {\n
\tpublic \$default = array(\n
\t\t'datasource' => 'Database/Mysql',\n
\t\t'persistent' => false,\n
\t\t'host' => 'localhost',\n
\t\t'login' => '$USER',\n
\t\t'password' => '$PASS',\n
\t\t'database' => '$DB',\n
\t\t'encoding' => 'utf8'\n
\t);\n
}"
rm -f ../app/Config/database.php
echo -e $CONFIG | sed "s/^[ ]*//" >> ../app/Config/database.php

echo
echo "Setup complete!"
echo