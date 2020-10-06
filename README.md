# backup-sync

This is a prototype of a startup utility to sync backup directories.

## Requirements

    sudo apt install inotify-tools rsync

## Installation

    # grab the script
    git clone https://github.com/tiagosimoes-euf/backup-sync.git
    # make it executable
    chmod a+w backup-sync.sh
    # copy the example config file
    cp example.backup-sync.cfg backup-sync.cfg
    # edit the active config file
    nano backup-sync.cfg
    # run the script in the background at login
    echo $PWD/backup-sync.sh >> ~/.profile
    # profit!

## Usage

    # go to your source directory under the parent directory being watched
    cd /WATCHDIR/sourcedir
    # add a destination directory to a destination file
    echo /destinationdir >> DESTFILE
    # any changes in the source will trigger a sync to the destination

---

Under active development...
