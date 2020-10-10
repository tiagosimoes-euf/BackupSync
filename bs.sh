#!/usr/bin/env bash

# Import configuration
source $(dirname $(realpath $0))/bs.cfg

if [[ ${NOTIFY} ]]; then
  notify-send "Hello ${USER}" "BackupSync is running in the background" -u normal  -t ${TIMEOUT} -i checkbox-checked-symbolic
fi

# Catch changes in the parent directory
inotifywait -m -r -q --format '%w' -e close_write ${WATCHDIR} | while read CHANGEPATH
do
  # Check for a file with sync destinations
  if [ -f "${CHANGEPATH}${DESTFILE}" ]; then
    mapfile -t lines < ${CHANGEPATH}${DESTFILE}
    for line in "${lines[@]}"
    do
      # Check if it is an actual directory
      if [[ -d ${line} ]]; then
        DESTPATH="${line}"
        # Sync everything to the destination except for the file with the sync destinations
        rsync -az ${CHANGEPATH} ${DESTPATH} --exclude=${DESTFILE}
        if [[ ${NOTIFY} ]]; then
          notify-send "BackupSync triggered!" "\nChanged: ${CHANGEPATH}\n\nUpdated: ${DESTPATH}" -u normal -t ${TIMEOUT} -i emblem-synchronizing-symbolic
        fi
      fi
    done
  fi
done
