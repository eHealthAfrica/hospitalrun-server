#!/usr/bin/env bash
nginx -g "daemon off;"
(crontab -l 2>/dev/null; echo "30 2 * * 1 /usr/bin/certbot-auto renew --quiet --no-self-upgrade >> /var/log/letsencrypt/le-renew.log") | crontab -
mkdir -p /var/log/letsencrypt && touch /var/log/letsencrypt/install.log
certbot-auto certonly --standalone --non-interactive --agree-tos --email devops@ehealthafrica.org -d ${DOMAIN_NAME} >> /var/log/letsencrypt/install.log &