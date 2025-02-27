#!/bin/bash

# --------- Variables (EDIT THESE) -------------
DB_NAME=""
DB_USER=""
DB_PASS=""
DB_HOST=""

WEB_ROOT="/var/www/html"

# ----------------------------------------------

# Update system packages
dnf update -y

# Install Apache and PHP (without MySQL server)
dnf install -y httpd php php-mysqlnd php-json php-gd php-xml php-mbstring php-opcache php-cli wget unzip

# Start & enable Apache
systemctl enable --now httpd

# Create the document root if it doesn't exist
mkdir -p $WEB_ROOT
cd $WEB_ROOT

# Remove default index.html if exists
rm -rf *

# Download and install WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

# Create wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
sed -i "s/username_here/${DB_USER}/" wp-config.php
sed -i "s/password_here/${DB_PASS}/" wp-config.php
sed -i "s/localhost/${DB_HOST}/" wp-config.php


# Download WP Offload Media plugin
wget -O $WEB_ROOT/wp-content/plugins/amazon-s3-and-cloudfront.zip https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.3.2.8.zip

# Extract the plugin
unzip $WEB_ROOT/wp-content/plugins/amazon-s3-and-cloudfront.zip -d $WEB_ROOT/wp-content/plugins/

# Cleanup
rm -f $WEB_ROOT/wp-content/plugins/amazon-s3-and-cloudfront.zip


# Set correct permissions
chown apache:apache $WEB_ROOT -R
chmod -R 755 $WEB_ROOT

# Allow .htaccess overrides (for permalinks)
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf
systemctl restart httpd


echo "WordPress installation complete."
