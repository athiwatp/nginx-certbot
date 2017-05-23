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

# Enable AMP
# cp etc/nginx/conf.d/amp.conf.tpl /etc/nginx/conf.d/amp.conf
# sed -i "s|{{DOMAIN}}|${DOMAIN}|g" /etc/nginx/conf.d/amp.conf

# [PRE]
# Ensure writable
# sudo chmod 700 -R /etc/letsencrypt/archive >> /dev/null

# Key exist?
# /etc/letsencrypt/live/$DOMAIN/fullchain.pem
# /etc/letsencrypt/live/$DOMAIN/privkey.pem
# We'll check only `fullchain.pem`
$certbot=$(docker ps -a -q --filter certbot/certbot)
if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
  echo "[certbot] Init : $DOMAIN"
  # docker exec -it $certbot -n --agree-tos --renew-by-default --email "${CERTBOT_EMAIL}" --webroot -w ${ACME_WWWROOT:/usr/share/nginx/html} -d $DOMAIN -d www.$DOMAIN
  # docker run certbot/certbot certonly -n --agree-tos --renew-by-default --email "${CERTBOT_EMAIL}" --webroot -w ${ACME_WWWROOT:-/usr/share/nginx/html} -d $DOMAIN -d www.$DOMAIN
else
  echo "[certbot] Already exist certificate, will skip init."
  exit 0
fi

# Enable https
# sed -i "s|{{DOMAIN}}|${DOMAIN}|g" /etc/nginx/conf.d/https.conf

# Diable http config to let https apply.
# mv /etc/nginx/conf.d/http.conf /etc/nginx/conf.d/http.conf.disable

# Restart to take effect
# nginx=$(docker ps -a -q --filter nginx)
# docker exec -it $nginx service nginx start
# docker exec -it $nginx -t
# docker exec -it $nginx -s reload

# [POST]
# Keep your private key secure by set the right permission so only you can read it at remote. 
# sudo chmod 400 -R /etc/letsencrypt/archive

# Ensure read only.
# sudo chmod 600 -R /etc/letsencrypt/archive /etc/letsencrypt/live/$DOMAIN/privkey.pem

# [CRON]
# Renewal, Add to daily cron
# cp /root/renew.sh /etc/cron.daily/renew.sh

# Ensure excutable
# chmod u+x /etc/cron.d/renew.sh