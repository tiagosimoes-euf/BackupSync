# BackupSync

This is a prototype of a startup utility to sync backup directories.

## Requirements

This script relies on a few tools that may not be immediately available in your system. On Debian/Ubuntu based systems, run the following command to install the necessary dependencies:

    sudo apt install flock inotify-tools rsync

## Installation

First grab the script and appreciate the BS in all its glory!

    git clone https://github.com/tiagosimoes-euf/BackupSync.git
    cd BackupSync/ && ls -hAl

Copy the example config file and edit the active config file.

    cp example.bs.cfg bs.cfg
    nano bs.cfg

Make the main script and the helper scripts executable.

    chmod a+w bs.sh
    chmod a+w bschk.sh
    chmod a+w bsset.sh

Put these somewhere in your `$PATH` for easier access.

    sudo ln -s ${PWD}/bs.sh /usr/local/bin/bs
    sudo ln -s ${PWD}/bschk.sh /usr/local/bin/bschk
    sudo ln -s ${PWD}/bsset.sh /usr/local/bin/bsset

Now you can run `bs`, `bschk` or `bsset` from anywhere in the command line.

## Setup

To set up a particular sync, go to each source directory under the parent directory being watched and use the `bsset` command to add a destination directory to a destination file.

    cd /WATCHDIR/sourcedir
    bsset /path/to/destinationdir1
    bsset /path/to/destinationdir2
    ...

Now any changes in this source directory will trigger a sync to all the destinations defined.

## Usage

[Call BS](http://gph.is/PgdFS8) by typing `bs &` so that it runs in the background.

The main script can be added to the system autostart as well, and also bound to a keyboard shortcut.

To check if the main script is running, use `bschk`. Properly configured, this can be used with tools like the XFCE Generic Monitor plugin for the XFCE panel.

---

Under active development...
