# nginx-certbot
Automate `TLS/SSL` by `Certbot` with auto renewal via `Nginx` on `Ubuntu 16.04` (xenial)

## Status
- [ ] Proof of concept (NOT SUCCEED YET, DON'T USE!!!)

## Prerequisites
- Your registered domain name for `DOMAIN`.
- Domain name server pointed to your hosting.
- Domain name record already setup at hosting.
- Working email for `CERTBOT_EMAIL`.

## What happen while compose
1. Compose `nginx` with volumes.
    ```
    - /etc/nginx/conf.d:/etc/nginx/conf.d
    - /etc/ssl/dhparams.pem:/etc/ssl/dhparams.pem
    - /var/www:/var/www
    ```
1. Prepare `nginx` default `/usr/share/nginx/html` page for `--webroot`.
1. Compose `certbot` with volumes.
    ```
    - /etc/letsencrypt:/etc/letsencrypt
    - /var/lib/letsencrypt:/var/lib/letsencrypt
    - /var/log/letsencrypt:/var/log/letsencrypt
    ```

## What happen while init
1. Run `certbot` with `--webroot` challenge with `DOMAIN`, `CERTBOT_EMAIL` environment variables.
1. Create `dhparams.pem` with `dhparams.sh` if not volume.
1. Enable `SSL` by apply `https.conf` with `DOMAIN` environment variables.
1. Disable `http.conf` config.
1. Validate and restart `nginx`.
1. Copy renewal script `/root/renew.sh` to daily cron job.
1. Make `/root/renew.sh` executable.

## What happen while renewal
1. Log to `/var/log/letsencrypt/daily.log`
1. Do renewal if need.

## How to use
```shell
# Config you domain and email.
cp .env.example .env
nano .env

# Compose to remote by docker-machine. (or something else)
```