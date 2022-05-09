#!/bin/sh

chmod a+rx /opt/cronjob.sh
chmod a+rx /opt/cronjob-sync-sitemap-from-efs.sh
crontab -l > /opt/cronjobconfnew
cat /opt/cronjobconf >> /opt/cronjobconfnew
crontab /opt/cronjobconfnew
echo ""
crontab -l
rm -vf /opt/cronjobconf /opt/cronjobconfnew
