#!/usr/bin/env bash

# Set the main variables
SCRIPTPATH=$(dirname $(realpath $0))
CONFIGEXAMPLE='example.bs.cfg'
CONFIGFILE='bs.cfg'

# Assert a configuration file
if [[ ! -f ${SCRIPTPATH}/${CONFIGFILE} ]]; then
  cp ${SCRIPTPATH}/${CONFIGEXAMPLE} ${SCRIPTPATH}/${CONFIGFILE}
fi

# Import configuration
source ${SCRIPTPATH}/${CONFIGFILE}

# Check if the lock file exists
if [[ -f ${LOCKFILE} ]]; then
  STATUS="On"
  MESSAGE="BackupSync is running!"
  DETAILS="LOCKFILE: ${LOCKFILE}"
  ICON='system-run-symbolic'
else
  STATUS="Off"
  MESSAGE="BackupSync is stopped."
  DETAILS="LOCKFILE not found."
  ICON='process-stop-symbolic'
fi

# Get options
while getopts ":m:t" opt; do
case ${opt} in
  # Set output mode
  m )
    BSCHKMOD=${OPTARG}
    ;;
  # Toggle BS On and Off
  t )
    if [[ ${STATUS} == "On" ]]; then
      MESSAGE="Stopping BackupSync..."
      DETAILS="Terminate process $(cat $LOCKFILE)."
      ICON='process-stop-symbolic'
      pkill -TERM -P $(cat $LOCKFILE)
      wait
    else
      MESSAGE="Starting BackupSync..."
      bs &
      DETAILS="Running in the background."
      ICON='system-run-symbolic'
    fi
    ;;
  * )
    # Best. Handling. Ever.
    echo -e "\033[01mWAT?!\033[0m"
    ;;
esac
done

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
    echo "<txtclick>bschk -t -m NOTIFY</txtclick>"
    ;;
  * )
    echo -e ${MESSAGE}
    ;;
esac
