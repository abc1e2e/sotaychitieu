#!/bin/sh

set +e

# mount AWS EFS
sleep 1 && echo "[$(date -Iseconds)] ls -Al /var/efs"
ls -Al /var/efs
if [[ ! -d /var/efs/public/sitemaps ]]; then
  sleep 1 && echo "[$(date -Iseconds)] mkdir -vp /var/efs/public/sitemaps"
  mkdir -vp /var/efs/public/sitemaps
fi
sleep 1 && echo "[$(date -Iseconds)] ls -Al /var/efs/public"
ls -Al /var/efs/public

: <<-'COMMENT_BLOCK'
if [[ -d /var/www/public ]]; then
  sleep 1 && echo "[$(date -Iseconds)] rm -Rf /var/www/public_old"
  rm -Rf /var/www/public_old
  sleep 1 && echo "[$(date -Iseconds)] mv -vf /var/www/public /var/www/public_old"
  mv -vf /var/www/public /var/www/public_old
fi
sleep 1 && echo "[$(date -Iseconds)] ln -vs /var/efs/public /var/www/public"
ln -vs /var/efs/public /var/www/public
sleep 1 && echo "[$(date -Iseconds)] rsync -arvt /var/www/public_old/ /var/www/public/"
rsync -arvt /var/www/public_old/ /var/www/public/
sleep 1 && echo "[$(date -Iseconds)] rsync -arvc /var/www/public_old/ /var/www/public/"
rsync -arvc /var/www/public_old/ /var/www/public/
# sleep 1 && echo "[$(date -Iseconds)] cp -Rvf /var/www/public_old/ /var/www/public/"
# cp -Rvf /var/www/public_old/ /var/www/public/
sleep 1 && echo "[$(date -Iseconds)] ls -Al /var/www/public/"
ls -Al /var/www/public/
sleep 1 && echo "[$(date -Iseconds)] ls -Al /var/www/public/public_old/"
ls -Al /var/www/public/public_old/
sleep 1 && echo "[$(date -Iseconds)] ls -Al /var/www/public_old/"
ls -Al /var/www/public_old/
sleep 1 && echo "[$(date -Iseconds)] rm -Rf /var/www/public_old"
rm -Rf /var/www/public_old

sleep 1 && echo "[$(date -Iseconds)] echo 'pong' > /var/www/public/ping"
echo 'pong' > /var/www/public/ping
COMMENT_BLOCK

export AWS_DEFAULT_REGION='ap-northeast-1'
export HYOBAN_S3_BUCKET_PUBLIC='hyoban-stag-s3-bucket-public'

sleep 1 && echo "[$(date -Iseconds)] /usr/bin/aws s3 sync --exact-timestamps s3://${HYOBAN_S3_BUCKET_PUBLIC}/pub/sitemap_data/ /var/www/public/"
/usr/bin/aws s3 sync --exact-timestamps s3://${HYOBAN_S3_BUCKET_PUBLIC}/pub/sitemap_data/ /var/www/public/

sleep 1 && echo "[$(date -Iseconds)] /usr/bin/aws s3 sync --exact-timestamps s3://${HYOBAN_S3_BUCKET_PUBLIC}/pub/html/ /var/www/public/html/"
/usr/bin/aws s3 sync --exact-timestamps s3://${HYOBAN_S3_BUCKET_PUBLIC}/pub/html/ /var/www/public/html/

: <<-'COMMENT_BLOCK'
sleep 1 && echo "[$(date -Iseconds)] chown -R nginx:nginx /var/www/public"
chown -R nginx:nginx /var/www/public
COMMENT_BLOCK
set -e

# run supervisor
sleep 1 && echo "[$(date -Iseconds)] /usr/bin/supervisord -c /etc/supervisord.conf"
/usr/bin/supervisord -c /etc/supervisord.conf
