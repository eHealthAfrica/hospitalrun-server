#!/usr/bin/env bash
(crontab -l 2>/dev/null; echo "30 2 * * 1 /usr/bin/certbot-auto renew --quiet --no-self-upgrade >> /var/log/letsencrypt/le-renew.log") | crontab -
mkdir -p /var/log/letsencrypt && touch /var/log/letsencrypt/install.log
certbot-auto certonly --standalone --non-interactive --agree-tos --email devops@ehealthafrica.org -d ${DOMAIN_NAME} 2>&1 | tee /var/log/letsencrypt/install.log \
               && if [ -f /etc/letsencrypt/live/${DOMAIN_NAME}/cert.pem ]; then
                       mv /etc/nginx/conf.d/defaultssl /etc/nginx/conf.d/defaultssl.conf \
                    && rm /etc/nginx/conf.d/default.conf  \
                    && nginx -s reload
                  fi \
               &
nginx -g "daemon off;"