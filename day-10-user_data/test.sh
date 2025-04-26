#! /bin/bash
sudo su -
yum update -y
yum install -y httpd
yum install git -y
cd /var/www/html
git clone https://github.com/sruthibv/css.git
cd css
mv * /var/www/html
cd ..
rm -rf css
service httpd start  
systemctl enable httpd
