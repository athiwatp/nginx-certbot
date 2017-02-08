#!/bin/sh
# https://github.com/certbot/certbot/issues/1833
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# Ensure script is call
echo $(date)'|Renewal' >> /var/log/letsencrypt/daily.log

# This script renews all the Let's Encrypt certificates with a validity < 30 days
if ! /opt/letsencrypt/letsencrypt-auto renew > /var/log/letsencrypt/renew.log 2>&1 ; then
    echo Automated renewal failed:
    cat /var/log/letsencrypt/renew.log
    exit 1
fi

# Restart to take effect
nginx -t && nginx -s reload
