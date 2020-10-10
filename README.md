# BackupSync

This is a prototype of a startup utility to sync backup directories.

## Requirements

    sudo apt install inotify-tools rsync

## Installation

    # grab the script
    git clone https://github.com/tiagosimoes-euf/BackupSync.git
    # appreciate the BS in all its glory
    cd BackupSync/ && ls -hAl
    # copy the example config file
    cp example.bs.cfg bs.cfg
    # edit the active config file
    nano bs.cfg
    # make the script executable
    chmod a+w bs.sh
    # put it somewhere in your $PATH
    sudo ln -s ${PWD}/bs.sh /usr/local/bin/bs
    # profit!

## Setup

    # go to your source directory under the parent directory being watched
    cd /WATCHDIR/sourcedir
    # add a destination directory to a destination file
    echo /destinationdir >> DESTFILE
    # any changes in the source will trigger a sync to the destination

## Usage

    # [Call BS](http://gph.is/PgdFS8)
    bs


---

Under active development...
