FROM alpine

# Nginx's config
RUN mkdir -p /etc/nginx/conf.d
COPY etc/nginx/conf.d /etc/nginx/conf.d

# Script
COPY root /root

# Renewal
COPY root/renew.sh /etc/cron.daily/renew.sh
RUN chmod u+x /etc/cron.daily/renew.sh

# Entry
WORKDIR /root

ENTRYPOINT [ "/root/init.sh" ]
