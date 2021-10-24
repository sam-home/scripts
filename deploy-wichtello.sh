#!/bin/sh

set +h
set -e

BUILD=$(date '+%Y%m%d%H%M%S')

# clean up

rm -rf wichtello-laravel-api

# download repository

git clone git@github.com:sam-home/wichtello-laravel-api.git

# setup repository

pushd wichtello-laravel-api
rm -rf .git

# create environment

cat > .env << EOF
APP_NAME=Wichtello
APP_ENV=production
APP_KEY=base64:SNEr8YaO+CNgiZGBuGb8+xKC8yNLKPPTXJ0uAk3gAoE=
APP_DEBUG=false
APP_URL=https://api.wichtello.com/

LOG_CHANNEL=stack
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=api.wichtello.com
DB_USERNAME=wichtello
DB_PASSWORD=bCmv8ep3VavS5nLM7g4v5j

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DRIVER=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=info@wichtello.develop
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_APP_CLUSTER=mt1

MIX_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
EOF

# install vendor

composer install

# test

php artisan test

# create archive

tar -cJf ../wichtello-laravel-api-$BUILD.tar.xz .
popd

# deploy to server

scp wichtello-laravel-api-$BUILD.tar.xz wichtello.com:api.wichtello.com/
ssh wichtello.com mkdir api.wichtello.com/wichtello-laravel-api-$BUILD
ssh wichtello.com tar -xf api.wichtello.com/wichtello-laravel-api-$BUILD.tar.xz \
	--directory api.wichtello.com/wichtello-laravel-api-$BUILD
ssh wichtello.com unlink api.wichtello.com/public
ssh wichtello.com ln -s /var/www/vhosts/wichtello.com/api.wichtello.com/wichtello-laravel-api-$BUILD/public \
	api.wichtello.com/public
