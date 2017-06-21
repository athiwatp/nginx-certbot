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

echo "[certbot] Begin..."

# Key exist?
# /etc/letsencrypt/live/$DOMAIN/fullchain.pem
# /etc/letsencrypt/live/$DOMAIN/privkey.pem
# We'll check only `fullchain.pem`
$certbot=$(docker ps -a -q --filter certbot/certbot)
if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
  echo "[certbot] Init : $DOMAIN"
  # [PRE]
  # Ensure writable
  sudo chmod 700 -R /etc/letsencrypt/archive >> /dev/null
  # Do certbot
  docker exec -it $certbot -n --agree-tos --renew-by-default --email "${CERTBOT_EMAIL}" --webroot -w ${ACME_WWWROOT:/usr/share/nginx/html} -d $DOMAIN -d www.$DOMAIN
else
  echo "[certbot] Already exist certificate, will skip."
  exit 0
fi

# Enable https
sed -e "s/{{DOMAIN}}/$DOMAIN/g" /etc/nginx/conf.d/https.conf.tmpl > /etc/nginx/conf.d/default.conf

# Disable http config to let https apply.
mv /etc/nginx/conf.d/http.conf /etc/nginx/conf.d/http.conf.disable

# Restart to take effect
nginx=$(docker ps -a -q --filter nginx)
docker exec -it $nginx service nginx start && nginx -t && nginx -s reload

# [POST]
# Keep your private key secure by set the right permission so only you can read it at remote. 
sudo chmod 400 -R /etc/letsencrypt/archive

# Ensure read only.
sudo chmod 600 -R /etc/letsencrypt/archive /etc/letsencrypt/live/$DOMAIN/privkey.pem

# [CRON]
# Renewal, Add to daily cron
cp ./etc/cron.daily/renew.sh /etc/cron.daily/renew.sh

# Ensure excutable
chmod u+x /etc/cron.daily/renew.sh
