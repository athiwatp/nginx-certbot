#!/bin/sh

# Required
if [ -z ${DOMAIN+x} ]; then
    echo "[Error] Required parameters : DOMAIN"
    return;
fi

if [ -z ${CERTBOT_EMAIL+x} ]; then
    echo "[Error] Required parameters : CERTBOT_EMAIL"
    return;
fi

echo "Setup Nginx..."

# AMP
cp /etc/nginx/conf.d/amp.conf.tpl /etc/nginx/conf.d/amp.conf
sed -i "s|{{DOMAIN}}|${DOMAIN}|g" /etc/nginx/conf.d/amp.conf
sudo service nginx start && sudo nginx -t && sudo nginx -s reload

# Wait for nginx to sleep...
sleep 5

# [PRE]
# Ensure writable
sudo chmod 700 -R /etc/letsencrypt/archive

# Key exist?
# /etc/letsencrypt/live/$DOMAIN/fullchain.pem
# /etc/letsencrypt/live/$DOMAIN/privkey.pem
# We'll check only `fullchain.pem`
if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
  echo "[certbot] Init : $DOMAIN"
  certbot certonly -t -n --agree-tos --renew-by-default --email "${CERTBOT_EMAIL}" --webroot -w ${ACME_WWWROOT:-/var/www/html} -d $DOMAIN -d www.$DOMAIN
else
  echo "[certbot] Already exist certificate, will skip init."
  ls /etc/letsencrypt/live/$DOMAIN
fi

# Enable SSL
cp /etc/nginx/conf.d/https.conf.tpl /etc/nginx/conf.d/https.conf
sed -i "s|{{DOMAIN}}|${DOMAIN}|g" /etc/nginx/conf.d/https.conf
sudo service nginx start && sudo nginx -t && sudo nginx -s reload

# [POST]
# Keep your private key secure by set the right permission so only you can read it at remote. 
sudo chmod 400 -R /etc/letsencrypt/archive

# Ensure read only.
sudo chmod 600 -R /etc/letsencrypt/archive /etc/letsencrypt/live/$DOMAIN/privkey.pem