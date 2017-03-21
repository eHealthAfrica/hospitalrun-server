FROM nginx:1.11.10
LABEL Maintainer Mofesola Babalola <mofesola.babalola@ehealthnigeria.org>

ARG DOMAIN_NAME

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee /etc/apt/sources.list.d/backports.list
RUN apt-get -y update && apt-get install -y cron curl lsof at

ENV DOMAIN_NAME $DOMAIN_NAME
COPY conf/certbot-auto /usr/bin/
RUN mkdir -p /etc/letsencrypt/live/$DOMAIN_NAME
COPY conf/certs/* /etc/letsencrypt/live/$DOMAIN_NAME/

WORKDIR /etc/nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf.tmpl /etc/nginx/conf.d/default.conf.tmpl
COPY conf/hospitalrun-dev.conf /etc/nginx/conf.d/hospitalrun-dev.conf
COPY conf/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh && chmod a+x /usr/bin/certbot-auto && envsubst < /etc/nginx/conf.d/default.conf.tmpl > /etc/nginx/conf.d/default.conf

ENTRYPOINT /etc/nginx/entrypoint.sh
EXPOSE 80 443