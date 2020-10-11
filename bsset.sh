#!/usr/bin/env bash

# Import configuration
CONFIGFILE='bs.cfg'

source $(dirname $(realpath $0))/${CONFIGFILE}

# If no file is present, initialize it
if [[ ! -f ${PWD}/${DESTFILE} ]]; then
  echo "[BackupSync]" > ${DESTFILE}
fi

# Get options
while getopts ":d:le" opt; do
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
        echo $(realpath ${OPTARG}) >> ${DESTFILE}
      fi
    fi
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
  e )
    # Open the file in the defined text editor
    ${EDITOR} ${DESTFILE}
    ;;
  * )
    # Best. Handling. Ever.
    echo -e "\033[01mWAT?!\033[0m"
    ;;
esac
done
