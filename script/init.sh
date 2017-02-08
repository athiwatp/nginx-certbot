#!/bin/sh

# Required
if [ -z ${DOMAINNAME+x} ]; then
    echo "[Error] Required parameters : DOMAINNAME"
    return;
fi

echo "Setup Nginx..."

# Setup domain name
sed -i "s|__DOMAINNAME__|${DOMAINNAME}|g" /etc/nginx/conf.d/service.conf

# Setup wwwroot
cp -f ./var/www/index.html /var/www/${DOMAINNAME}/index.html

# Generate stronger, 4096 bit long DH parameters.
if [ ! -f /etc/ssl/dhparams.pem ]; then
    echo "Create dhparams..."
    # Create a directory for our SSL certificates
    sudo mkdir /etc/ssl

    # Generate stronger, 4096 bit long DH parameters.
    sudo openssl dhparam -out /etc/ssl/dhparams.pem 4096

    # Read only.
    chmod 600 /etc/ssl/dhparams.pem
fi

# Disable SSL configuration and let it run without SSL
mv -v /etc/nginx/conf.d /etc/nginx/conf.d.disabled

# Wait for nginx...
sleep 5

# Install
DEBIAN_FRONTEND=noninteractive && sudo apt-get -y update && sudo apt-get -y install letsencrypt

# Ensure writable
sudo chmod 700 -R /etc/letsencrypt/archive

# Custom html?
ACME_WWWROOT = ${ACME_WWWROOT:-/usr/share/nginx/html}

# Key exist?
# /etc/letsencrypt/live/$DOMAINNAME/fullchain.pem
# /etc/letsencrypt/live/$DOMAINNAME/privkey.pem
# We'll check only `fullchain.pem`
if [ ! -f /etc/letsencrypt/live/$DOMAINNAME/fullchain.pem ]; then
  echo "[certbot] Create : $DOMAINNAME, www.$DOMAINNAME -> $ACME_WWWROOT"
  certbot certonly -t -n --agree-tos --renew-by-default --email "${EMAIL}" --webroot -w $ACME_WWWROOT -d $DOMAINNAME -d www.$DOMAINNAME
else
  echo "[certbot] Exist."
  ls /etc/letsencrypt/live/$DOMAINNAME
fi

# Use 443 instead of 80
if [ ! -f /etc/nginx/conf.d/service.conf ]; then
  rm -f /etc/nginx/conf.d/default.conf 2>/dev/null
  mv -v /etc/nginx/conf.d.disabled /etc/nginx/conf.d
fi

# Keep your private key secure by set the right permission so only you can read it at remote. 
sudo chmod 400 -R /etc/letsencrypt/archive

# Start nginx service
sudo service nginx start
sudo nginx -t && sudo nginx -s reload
