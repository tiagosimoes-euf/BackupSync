#!/usr/bin/env bash

# Set the main variables
SCRIPTPATH=$(dirname $(realpath $0))
CONFIGEXAMPLE='example.bs.cfg'
CONFIGFILE='bs.cfg'
INCLUDEEXAMPLE='example.rsync.include'

# Assert a configuration file
if [[ ! -f ${SCRIPTPATH}/${CONFIGFILE} ]]; then
  cp ${SCRIPTPATH}/${CONFIGEXAMPLE} ${SCRIPTPATH}/${CONFIGFILE}
fi

# Import configuration
source ${SCRIPTPATH}/${CONFIGFILE}

# If no file is present, initialize it
if [[ ! -f ${PWD}/${DESTFILE} ]]; then
  echo "[BackupSync]" > ${PWD}/${DESTFILE}
fi

# Get options
while getopts ":d:elr" opt; do
case ${opt} in
  d )
    # Check if it is an actual directory
    if [[ ! -d $(realpath ${OPTARG}) ]]; then
      echo "Not a valid directory!"
    else
      # Check that it does not already exist in the file
      HITS=0
      mapfile -t lines < ${PWD}/${DESTFILE}
      for line in "${lines[@]}"
      do
        if [[ ${line} == $(realpath ${OPTARG}) ]]; then
          echo "Already present in the file."
          HITS+=1
        fi
      done
      if [[ ${HITS} == 0 ]]; then
        echo -e "Adding destination to the list:\n$(realpath ${OPTARG})"
        echo $(realpath ${OPTARG}) >> ${PWD}/${DESTFILE}
      fi
    fi
    ;;
  e )
    # Open the file in the defined text editor
    ${EDITOR} ${PWD}/${DESTFILE}
    ;;
  l )
    echo -e "Set to sync to the following destination directories:"
    mapfile -t lines < ${PWD}/${DESTFILE}
    for line in "${lines[@]}"
    do
      # Check if it is an actual directory
      if [[ -d ${line} ]]; then
        echo ${line}
      fi
    done
    ;;
  r )
    # Assert an include file for rsync and open it in the text editor
    if [[ ! -f ${PWD}/${INCLUDEFILE} ]]; then
      cp ${SCRIPTPATH}/${INCLUDEEXAMPLE} ${PWD}/${INCLUDEFILE}
    fi
    ${EDITOR} ${PWD}/${INCLUDEFILE}
    ;;
  * )
    # Best. Handling. Ever.
    echo -e "\033[01mWAT?!\033[0m"
    ;;
esac
done
