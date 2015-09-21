#!/bin/sh

chown -R vancan1ty:daemon $1
cd $1
mv hooks/post-update.sample hooks/post-update
chmod a+x hooks/post-update
echo "$2" > description
