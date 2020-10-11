#!/usr/bin/env bash

# Set the main variables
SCRIPTPATH=$(dirname $(realpath $0))
CONFIGEXAMPLE='example.bs.cfg'
CONFIGFILE='bs.cfg'
INCLUDEEXAMPLE='example.rsync.include'
LOGPATH=${SCRIPTPATH}/'log'

# Assert a configuration file
if [[ ! -f ${SCRIPTPATH}/${CONFIGFILE} ]]; then
  cp ${SCRIPTPATH}/${CONFIGEXAMPLE} ${SCRIPTPATH}/${CONFIGFILE}
fi

# Import configuration
source ${SCRIPTPATH}/${CONFIGFILE}

# Assert an include file for rsync
if [[ ! -f ${SCRIPTPATH}/${INCLUDEFILE} ]]; then
  cp ${SCRIPTPATH}/${INCLUDEEXAMPLE} ${SCRIPTPATH}/${INCLUDEFILE}
fi

# Assert a log directory
if [[ ! -d ${LOGPATH} ]]; then
  mkdir -p ${LOGPATH}
fi

# Make sure only one process runs at a time
exec 200>${LOCKFILE} || exit 1
flock -n 200 || exit 1
trap 'rm -f ${LOCKFILE}' EXIT

# Startup notification
if [[ ${NOTIFY} ]]; then
  notify-send "Hello ${USER}" \
  "BackupSync is running in the background" \
  -u normal -t ${TIMEOUT} -i checkbox-checked-symbolic
fi

# Catch changes in the parent directory
inotifywait -m -r -q \
--exclude ${DESTFILE} --exclude ${INCLUDEFILE} --exclude '.swp$' \
--format '%w' -e close_write ${WATCHDIR} | \
while read CHANGEPATH
do
  # Check for a file with sync destinations
  if [[ -f "${CHANGEPATH}${DESTFILE}" ]]; then
    # Check for a local rsync include file or use the default one
    if [[ -f ${CHANGEPATH}${INCLUDEFILE} ]]; then
      INCLUDE=${CHANGEPATH}${INCLUDEFILE}
    else
      INCLUDE=${SCRIPTPATH}/${INCLUDEFILE}
    fi

    # Start logging the event
    LOGFILE=${LOGPATH}/"$(date +"%Y_%m_%d").log"
    echo "[$(date +"%H_%M_%S")] Changed: ${CHANGEPATH}" >> ${LOGFILE}

    # Load the destinations file
    mapfile -t lines < ${CHANGEPATH}${DESTFILE}
    for line in "${lines[@]}"
    do
      # Check if it is an actual directory
      if [[ -d ${line} ]]; then
        DESTPATH="${line}"
        # Sync only the correct files to the destination
        OUTPUT=( $(rsync -az ${CHANGEPATH} ${DESTPATH} --exclude=${DESTFILE} \
        --include-from=${INCLUDE} --exclude='*' \
        --info=name1) )
        echo ${#OUTPUT[@]}
        echo "[$(date +"%H_%M_%S")] Updated: ${DESTPATH}" >> ${LOGFILE}
      fi
    done

    # Check the output from rsync for changes other than the docroot
    SYNCED=(${OUTPUT[@]:1})
    echo ${#SYNCED[@]}
    NOTIFYSTR=""
    if [[ ${SYNCED} ]]; then
      echo -e "[File list]" >> ${LOGFILE}
      for file in "${SYNCED[@]}"
      do
        echo ${file} >> ${LOGFILE}
        NOTIFYSTR+="${file}\n"
      done
    fi

    # Check if there is anything to report
    if [[ ${NOTIFY} ]] && [[ ${NOTIFYSTR} ]]; then
      notify-send "BackupSync triggered!" \
      "${NOTIFYSTR}" \
      -u normal -t ${TIMEOUT} -i emblem-synchronizing-symbolic
    fi
  fi
done
