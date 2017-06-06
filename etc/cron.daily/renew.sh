#!/bin/sh
# https://github.com/certbot/certbot/issues/1833
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# Ensure script is call
echo $(date)'|[Renewal] : Start... ' >> /var/log/letsencrypt/daily.log

# Try renewal and call renew hook
certbot renew --pre-hook "echo $(date)'|[Renewal] : pre-hook.' >> /var/log/letsencrypt/daily.log" --post-hook "docker-compose restart nginx"