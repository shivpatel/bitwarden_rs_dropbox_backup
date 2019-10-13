#!/bin/sh

# setup dropbox uploader config file
echo "OAUTH_ACCESS_TOKEN=${DROPBOX_ACCESS_TOKEN}" > ~/.dropbox_uploader

# run backup once on container start to ensure it works
/backup.sh

# start crond in foreground
exec crond -f