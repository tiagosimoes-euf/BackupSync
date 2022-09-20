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
    bsset -d /path/to/destinationdir1
    bsset -d /path/to/destinationdir2
    ...

Now any changes in this source directory will trigger a sync to all the destinations defined.

Use `bsset -l` to list all the destinations in the file and `bsset -e` to edit the file manually.

### Configuring rsync filters

The approach to `rsync` is to **exclude all** but the patterns defined in the `.rsync.include` file at the project root. It is possible to define different rules for each source directory by running `bsset -r` which will copy the example file to that directory and open it in the text predefined text editor. Due to the way `rsync` works, this file will be ignored when syncing.

## Usage

[Call BS](http://gph.is/PgdFS8) by typing `bs &` so that it runs in the background.

### Check the status

To check if the main script is running, use `bschk`. The check script will display a message according with the configuration file, but this can be overridden by passing a flag to the command:

    bschk -m DEFAULT    # echoes in the command line
    bschk -m NOTIFY     # displays a system notification
    bschk -m GENMON     # outputs XML for the XFCE Panel Generic Monitor

### Toggle On/Off

Use `bschk -t` to toggle BackupSync *on* and *off*! If the script is running, this command will kill the child processes and switch it off. If the script is not running, it will start it running in the background.

You can combine it with another flag like `bschk -t -m NOTIFY` and bind it to a keyboard shortcut for bonus points!

## Known issues

Sometimes this error may prevent the script from starting:

    Failed to watch /home/ts/dev/00_BACKUP; upper limit on inotify watches reached!
    Please increase the amount of inotify watches allowed per user via `/proc/sys/fs/inotify/max_user_watches'.

Refer to [this StackOverflow answer](https://stackoverflow.com/a/53078114) for details on how to solve it.

---

_in memoriam_ Tiago Seco (1984 - 2022)
