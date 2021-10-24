#!/bin/bash

HOST=stage.besichtigung.viantis.de
REPOSITORY=

git clone ...
cd ...

yarn
yarn build

NAME=$(node -pe "require('./package.json').name")
VERSION=$(node -pe "require('./package.json').version")
BUILD=$(date +%Y%m%d%H%M%S)

cd dist/$NAME
tar -cf ../../$NAME-$VERSION-$BUILD.tar.xz .
cd ..
cd ..

scp $NAME-$VERSION-$BUILD.tar.xz $HOST:~

rm $NAME-$VERSION-$BUILD.tar.xz

ssh $HOST bash << EOF
mkdir $NAME-$VERSION-$BUILD
cd $NAME-$VERSION-$BUILD
tar -xf ../$NAME-$VERSION-$BUILD.tar.xz
EOF
