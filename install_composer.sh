#!/bin/sh

#EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
#php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
#
#if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
#then
#    >&2 echo 'ERROR: Invalid installer signature'
#    rm composer-setup.php
#    exit 1
#fi

curl -o composer-setup.php https://getcomposer.org/installer

php composer-setup.php --quiet --version=1.10.16
RESULT=$?
rm composer-setup.php
exit $RESULT
