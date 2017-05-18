# Ensure script is call
echo $(date)'|Renewal' >> /var/log/letsencrypt/daily.log

# Try renewal with service restart if need
certbot renew --pre-hook "service nginx stop" --post-hook "service nginx start" >> /var/log/letsencrypt/daily.log