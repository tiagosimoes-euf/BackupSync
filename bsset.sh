#!/usr/bin/env bash

# Import configuration
CONFIGFILE='bs.cfg'

source $(dirname $(realpath $0))/${CONFIGFILE}

if [[ ! -f ${PWD}/${DESTFILE} ]]; then
  echo "[BackupSync]" > ${DESTFILE}
fi
