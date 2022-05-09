#!/bin/sh -ex

rm -vf /etc/nginx/conf.d/default.conf
touch /run/nginx.pid
chown -R nginx:nginx /run/nginx.pid
# chown -R nginx:nginx /etc/nginx/.htpasswd
mkdir -p /var/tmp/nginx
chown -R nginx:nginx /var/lib/nginx
chown -R nginx:nginx /var/tmp/nginx
chown -R nginx:nginx /var/log/nginx
chmod 775 /var/log/nginx
touch /run/supervisord.pid
chown -R nginx:nginx /run/supervisord.pid
mkdir -p /var/www
mkdir -p /var/efs
find /var/log/nginx -type d -exec chmod 775 {} \;
find /var/log/nginx -type f -exec chmod 664 {} \;
