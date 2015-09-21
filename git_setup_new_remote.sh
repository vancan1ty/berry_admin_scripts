#!/bin/sh

mkdir $1
cd $1
git init --bare
git update-server-info
mv hooks/post-update.sample hooks/post-update
chmod a+x hooks/post-update
echo "$2" > description
cd ..
chown -R vancan1ty:daemon $1


