#!/bin/sh -ex

rm -Rf docker .git* Dockerfile db-changelog trusted-ca.cer

# chmod +x ./install_composer.sh
# ./install_composer.sh
# rm -vf ./install_composer.sh

# github_token_composer_install=
# if [[ "${github_token_composer_install}" != "" ]]; then
#   ./composer.phar config -g github-oauth.github.com "${github_token_composer_install}"
# fi

# ./composer.phar install --optimize-autoloader --no-dev
# php artisan config:cache
# php artisan route:cache
# php artisan optimize
# php artisan opcache:clear
# php artisan opcache:compile --force

echo 'pong' > /var/www/public/ping

chown -R nginx:nginx .

# mkdir -p /var/hyoban/ssh/
# mv ./sftp_ssh_key_private /var/hyoban/ssh/
# chown -R nginx:nginx /var/hyoban/ssh
# chmod 600 /var/hyoban/ssh/sftp_ssh_key_private
