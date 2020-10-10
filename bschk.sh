#!/usr/bin/env bash

# Import configuration
CONFIGFILE='bs.cfg'

source $(dirname $(realpath $0))/${CONFIGFILE}

# Check if the lock file exists
if [[ -f ${LOCKFILE} ]]; then
  STATUS="On"
  MESSAGE="BackupSync is running!"
  DETAILS="LOCKFILE: ${LOCKFILE}"
  ICON='checkbox-checked-symbolic'
else
  STATUS="Off"
  MESSAGE="BackupSync is stopped."
  DETAILS="LOCKFILE not found."
  ICON='action-unavailable-symbolic'
fi

# Present the result according to the BS Check mode
case ${BSCHKMOD} in
  'DEFAULT' )
    echo -e ${MESSAGE}
    echo -e ${DETAILS}
    ;;
  'NOTIFY' )
    notify-send "${MESSAGE}" "${DETAILS}"\
    -u normal -t ${TIMEOUT} -i ${ICON}
    ;;
  'GENMON' )
    echo "<txt> BS: ${STATUS} </txt>"
    echo -e "<tool>${MESSAGE}\n${DETAILS}</tool>"
    ;;
  * )
    echo -e ${MESSAGE}
    ;;
esac
