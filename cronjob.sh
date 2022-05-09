#!/bin/sh

echo "[$(date -Iseconds)] cron job php artisan schedule:run"
cd /var/www/
php artisan schedule:run
