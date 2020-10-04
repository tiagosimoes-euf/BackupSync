#!/usr/bin/env bash

# https://www.maketecheasier.com/desktop-notifications-for-linux-command/
notify-send "Hello $USER" "backup-sync is running" -u normal -i checkbox-checked-symbolic

# load JSON file
config=$PWD/config.json
# load variables
watchdir=`jq '.watchdir' -r < $config`
