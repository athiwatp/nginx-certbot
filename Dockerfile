FROM nginx:alpine
MAINTAINER katopz <katopz@gmail.com>

# Nginx's config
RUN mkdir -p /etc/nginx/conf.d
ADD etc/nginx/conf.d/service.conf /etc/nginx/conf.d/

# Initial, Will ask for certificate.
ADD script/init.sh /usr/src/

# Renewal, Add to daily cron
ADD script/renewal.sh /etc/cron.daily/

# Ensure excutable
RUN \
 chmod +x /usr/src/init.sh && \
 chmod +x /etc/cron.daily/renewal.sh

# TLS/SSL
RUN mkdir -p /etc/ssl
ADD /etc/ssl/dhparams.pem /etc/ssl/
RUN chmod 600 /etc/ssl/dhparams.pem

# Entry
WORKDIR /usr/src
ENTRYPOINT ./init.sh