server {
  # Redirect .well-known/acme-challenge
  location '/.well-known/acme-challenge' {
    root /var/www/html;
    index acme.html;
  }
}