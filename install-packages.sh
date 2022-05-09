!/bin/sh -ex

CURRENT_DIR=$(pwd)

cd /var/tmp/
TEMP_DIR=$(pwd)

apk update
apk --no-cache add ca-certificates
update-ca-certificates
apk --no-cache add nginx supervisor curl git file binutils rsync gmp-dev ffmpeg cpulimit

# install AWS CLI
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
which pip3
pip3 --version
pip3 install awscli --upgrade
which aws
/usr/bin/aws --version

docker-php-source extract
apk --no-cache add build-base linux-headers perl-dev openssl-dev libzip-dev pcre-dev zlib-dev libxml2-dev libxslt-dev freetype-dev libjpeg-turbo-dev libpng-dev gd-dev geoip-dev

# install nginx
curl -sSL https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz -o headers-more-nginx-module-v0.33.tar.gz
tar -xzf headers-more-nginx-module-v0.33.tar.gz
curl -sSL https://nginx.org/download/nginx-1.16.1.tar.gz -o nginx-1.16.1.tar.gz
tar -xzf nginx-1.16.1.tar.gz
cd "${TEMP_DIR}/nginx-1.16.1"
./configure \
  --prefix=/var/lib/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --pid-path=/run/nginx/nginx.pid \
  --lock-path=/run/nginx/nginx.lock \
  --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
  --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
  --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
  --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
  --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
  --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
  --user=nginx \
  --group=nginx \
  --with-threads \
  --with-file-aio \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module=dynamic \
  --with-http_image_filter_module=dynamic \
  --with-http_geoip_module=dynamic \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  --with-http_perl_module=dynamic \
  --with-mail=dynamic \
  --with-mail_ssl_module \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_geoip_module=dynamic \
  --with-stream_ssl_preread_module \
  --add-module="${TEMP_DIR}/headers-more-nginx-module-0.33"

make
make install
cd "${TEMP_DIR}"

docker-php-ext-install bcmath pdo_mysql zip opcache exif gmp gd
docker-php-source delete

cd "${CURRENT_DIR}"

# clean up
rm -Rf "${TEMP_DIR}/nginx-1.16.1"
rm -Rf "${TEMP_DIR}/headers-more-nginx-module-0.33"
apk --no-cache del build-base linux-headers perl-dev openssl-dev pcre-dev zlib-dev libxml2-dev libxslt-dev freetype-dev libjpeg-turbo-dev libpng-dev geoip-dev

curl -o composer-setup.php https://getcomposer.org/installer

php composer-setup.php --quiet --version=1.10.16
RESULT=$?
rm composer-setup.php
exit $RESULT
