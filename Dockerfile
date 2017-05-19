FROM alpine
MAINTAINER katopz <katopz@gmail.com>

# Nginx's config
COPY etc/nginx/conf.d /etc/nginx/conf.d
COPY root /

# Nginx's default page
COPY /var/www/html /var/www/html

# Entry
WORKDIR /root

ENTRYPOINT [ "sh" ]
# CMD [".", "./init.sh"]
