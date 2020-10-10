#!/usr/bin/env bash

# Make sure only one process runs at a time
LOCKFILE='/var/tmp/bslock.lock'

exec 200>${LOCKFILE} || exit 1
flock -n 200 || exit 1
trap 'rm -f ${LOCKFILE}' EXIT

# Import configuration
CONFIGFILE='bs.cfg'

source $(dirname $(realpath $0))/${CONFIGFILE}

if [[ ${NOTIFY} ]]; then
  notify-send "Hello ${USER}" \
  "BackupSync is running in the background" \
  -u normal  -t ${TIMEOUT} -i checkbox-checked-symbolic
fi

# Catch changes in the parent directory
inotifywait -m -r -q --format '%w' -e close_write ${WATCHDIR} | \
while read CHANGEPATH
do
  # Check for a file with sync destinations
  if [[ -f "${CHANGEPATH}${DESTFILE}" ]]; then
    mapfile -t lines < ${CHANGEPATH}${DESTFILE}
    for line in "${lines[@]}"
    do
      # Check if it is an actual directory
      if [[ -d ${line} ]]; then
        DESTPATH="${line}"
        # Sync everything to the destination except for the destinations file
        rsync -az ${CHANGEPATH} ${DESTPATH} --exclude=${DESTFILE}
        if [[ ${NOTIFY} ]]; then
          notify-send "BackupSync triggered!" \
          "\nChanged: ${CHANGEPATH}\n\nUpdated: ${DESTPATH}" \
          -u normal -t ${TIMEOUT} -i emblem-synchronizing-symbolic
        fi
      fi
    done
  fi
done
