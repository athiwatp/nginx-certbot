FROM alpine
MAINTAINER katopz <katopz@gmail.com>

# Nginx's config
COPY etc/nginx/conf.d etc/nginx/conf.d

# Default page
COPY var/www/html /var/www/html

# Renewal, Add to daily cron
COPY root/renew.sh /etc/cron.daily/renew.sh

# Ensure excutable
RUN chmod u+x /etc/cron.d/renew.sh

# TLS/SSL
RUN mkdir -p /etc/ssl
COPY /etc/ssl/dhparams.pem /etc/ssl/
RUN chmod 600 /etc/ssl/dhparams.pem

# Volumes
VOLUME ["/etc/ssl/", "/etc/letsencrypt/live"]

# Entry
WORKDIR /root