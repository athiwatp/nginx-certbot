server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name default_server;

  # Redirect all HTTP requests to HTTPS with a 301 Moved Permanently response.
  location / {
    return 301 https://$host$request_uri;
  }
}

server {
  listen 443 ssl http2 default_server;
  listen [::]:443 ssl http2 default_server;
  server_name default_server;
  
  # enable ocsp stapling (mechanism by which a site can convey certificate revocation information to visitors in a privacy-preserving, scalable manner)
  # http://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
  ssl_stapling on;
  ssl_stapling_verify on;

  # enables server-side protection from BEAST attacks
  # http://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html
  ssl_prefer_server_ciphers on;

  # disable SSLv3(enabled by default since nginx 0.8.19) since it's less secure then TLS http://en.wikipedia.org/wiki/Secure_Sockets_Layer#SSL_3.0
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

  # https://wiki.mozilla.org/Security/Server_Side_TLS#Recommended_configurations
  ssl_ciphers "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA";
  ssl_certificate /etc/letsencrypt/live/{{DOMAIN}}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/{{DOMAIN}}/privkey.pem;

  # enable session resumption to improve https performance
  # http://vincent.bernat.im/en/blog/2011-ssl-session-reuse-rfc5077.html
  # With this shared session (of 10m), nginx will be able to handle 10 x 4000 sessions and the sessions will be valid for 1 hour.
  # https://leandromoreira.com.br/2015/10/12/how-to-optimize-nginx-configuration-for-http2-tls-ssl/
  ssl_session_cache shared:SSL:10m;
  ssl_session_timeout 1h;

  # Diffie-Hellman for TLS
  # https://weakdh.org/sysadmin.html
  ssl_dhparam "/etc/ssl/dhparams.pem";

  # Default
  location / {
    index index.html;
  }
}