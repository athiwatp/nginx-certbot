# Ensure script is call
echo $(date)'|Renewal' >> /var/log/letsencrypt/daily.log

# Try renewal and call renew hook
certbot renew --renew-hook /root/renew-hook.sh