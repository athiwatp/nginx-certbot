# Ensure script is call
echo $(date)'|[Renewal] : Start... ' >> /var/log/letsencrypt/daily.log

# Try renewal and call renew hook
certbot renew --renew-hook /root/renew-hook.sh