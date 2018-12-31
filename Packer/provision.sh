#!/bin/bash
set -e
#provision.sh
 sudo apt-get update -y
 echo "apt-get update done."
 #sudo apt-get install  nginx -y
 #sudo service nginx start

# sudo cp /tmp/index.php /var/www/html/index.php

sudo apt-get install apache2 php libapache2-mod-php awscli stress -y
sudo aws s3 cp s3://nh-onica/index.php /var/www/html
#cd /var/www/html && sudo git clone http://github.com/alphamusk/aws-metadata-php-page 

sudo service apache2 restart

