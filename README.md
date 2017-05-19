# nginx-certbot
Automate `TLS/SSL` by `Certbot` with auto renewal via `Nginx` on `Ubuntu 16.04` (xenial)

## Status
- [ ] Proof of concept (NOT SUCCEED YET, DON'T USE!!!)

## Prerequisites
- Your registered domain name for `DOMAIN`.
- Domain name server pointed to your hosting.
- Domain name record already setup at hosting.
- Working email for `CERTBOT_EMAIL`.

## What it do to setup
1. Compose `nginx` with volumes.
    ```
    - /etc/nginx/conf.d:/etc/nginx/conf.d
    - /etc/ssl/dhparams.pem:/etc/ssl/dhparams.pem
    - /var/www/html:/var/www/html
    ```
1. Prepare `nginx` default `HTML+AMP`⚡ page for `--webroot`.
1. Compose `certbot` with volumes.
    ```
    - /etc/letsencrypt:/etc/letsencrypt
    - /var/lib/letsencrypt:/var/lib/letsencrypt
    - /var/log/letsencrypt:/var/log/letsencrypt
    ```
1. Run `certbot` with `--webroot` challenge with `DOMAIN`, `CERTBOT_EMAIL` environment variables.
1. Create `dhparams.pem` with `dhparams.sh` if need.
1. Enable `SSL` by apply `ssl.conf.tpl` with `DOMAIN` environment variables.
1. Enable `AMP`⚡ by apply `amp.conf.tpl` with `DOMAIN` environment variables.
1. Disable default `nginx` config.
1. Validate and restart `nginx`.

## What it do to renewal
1. Copy renewal script to daily cron job and make it executable.
1. Log to `/var/log/letsencrypt`

## How to use
```shell
# Config you domain and email.
cp .env.example .env
nano .env
```