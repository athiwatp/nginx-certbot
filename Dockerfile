FROM alpine
MAINTAINER katopz <katopz@gmail.com>

# Nginx's config
RUN mkdir -p /etc/nginx/conf.d
COPY etc/nginx/conf.d /etc/nginx/conf.d
COPY root /root

# Nginx's default page
RUN mkdir -p /var/www/html
COPY var/www/html /var/www/html

# Entry
WORKDIR /root

ENTRYPOINT [ "sh" ]
# CMD [".", "./init.sh"]
