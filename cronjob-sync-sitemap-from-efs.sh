#!/bin/sh

export AWS_DEFAULT_REGION='ap-northeast-1'
export HYOBAN_S3_BUCKET_PUBLIC='hyoban-stag-s3-bucket-public'

echo "[$(date -Iseconds)] cron job sync site map from S3"
/usr/bin/aws s3 sync --exact-timestamps s3://${HYOBAN_S3_BUCKET_PUBLIC}/pub/sitemap_data/ /var/www/public/
/usr/bin/aws s3 sync --delete --exact-timestamps s3://${HYOBAN_S3_BUCKET_PUBLIC}/pub/html/ /var/www/public/html/

echo "[$(date -Iseconds)] chown -R nginx:nginx /var/www/public/"
chown -R nginx:nginx /var/www/public/
echo "[$(date -Iseconds)] find /var/www/public -type d -exec chmod a+rx {} \\;"
find /var/www/public -type d -exec chmod a+rx {} \;
echo "[$(date -Iseconds)] find /var/www/public -type f -exec chmod a+r {} \\;"
find /var/www/public -type f -exec chmod a+r {} \;
