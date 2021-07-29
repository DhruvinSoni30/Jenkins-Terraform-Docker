#! bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
touch index.html
echo "<h1> Dhruvin Soni </h1> > /var/www/html/index.html
