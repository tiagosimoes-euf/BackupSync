#!/usr/bin/env bash

# Import configuration
source backup-sync.cfg

if [[ $NOTIFY ]]; then
  notify-send "Hello $USER" "backup-sync is running in the background" -u normal  -t $TIMEOUT -i checkbox-checked-symbolic
fi

# Catch changes in the parent directory
inotifywait -m -r -q --format '%w' -e close_write $WATCHDIR | while read CHANGEPATH
do
  # Check for a file with sync destinations
  if [ -f "$CHANGEPATH$DESTFILE" ]; then
    mapfile -t lines < $CHANGEPATH$DESTFILE
    for line in "${lines[@]}"
    do
      # Check if it is an actual directory
      if [[ -d ${line} ]]; then
        DESTPATH="${line}"
        rsync -az $CHANGEPATH $DESTPATH --exclude=$DESTFILE
        if [[ $NOTIFY ]]; then
          notify-send "backup-sync triggered!" "\nChanged: $CHANGEPATH\n\nUpdated: $DESTPATH" -u normal -t $TIMEOUT -i emblem-synchronizing-symbolic
        fi
      fi
    done
  fi
done
