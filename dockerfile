FROM php:7.4.1-fpm-alpine3.11

# COPY trusted-ca.cer.pem /usr/local/share/ca-certificates/

COPY install-packages.sh /var/install-packages.sh
RUN chmod a+x /var/install-packages.sh 
RUN /var/install-packages.sh
RUN  rm -vf /var/install-packages.sh

COPY nginx.conf /etc/nginx/nginx.conf
# COPY .htpasswd /etc/nginx/.htpasswd
COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY supervisord.conf /etc/supervisord.conf

COPY config-packages.sh /var/config-packages.sh
RUN chmod a+x /var/config-packages.sh
RUN  /var/config-packages.sh 
RUN  rm -vf /var/config-packages.sh

COPY cronjobconf /opt/
COPY cronjob.sh /opt/
COPY cronjob-sync-sitemap-from-efs.sh /opt/
COPY cron-config.sh /opt/
RUN chmod a+x /opt/cron-config.sh 
RUN  /opt/cron-config.sh 
RUN  rm -vf /opt/cron-config.sh

COPY . /var/www
MAINTAINER dat
WORKDIR /var/www

COPY config-larevel.sh /var/config-larevel.sh
RUN chmod a+x /var/config-larevel.sh 
RUN  /var/config-larevel.sh 
RUN  rm -vf /var/config-larevel.sh

COPY entrypoint.sh /var/entrypoint.sh
RUN chmod a+x /var/entrypoint.sh

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
ENTRYPOINT ["/var/entrypoint.sh"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/ping
