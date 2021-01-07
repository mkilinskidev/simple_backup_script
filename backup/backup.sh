#!/bin/bash

DATE=$(date +%Y%m%d_%H%M)
HOME_DIR="/home/klient.dhosting.pl/USER"

echo "Starting backup..."

for i in $(cat $HOME_DIR/backup/websites.txt) 
do
    WEBSITE=$(echo $i | awk -F: '{print $1}')
    DATABASE=$(echo $i | awk -F: '{print $2}')
    MAINDIR=$HOME_DIR/backup/backup/$DATE/$WEBSITE

    mkdir -p $MAINDIR/files

    echo "Compressing $WEBSITE"	

    tar -zcpf "$MAINDIR/files/$WEBSITE.tar.gz" "$HOME_DIR/websites/$WEBSITE" 

    echo "Dumping database $DATABASE"

    mysqldump --defaults-extra-file=$HOME_DIR/.my.cnf $DATABASE > $MAINDIR/files/$WEBSITE.sql

    echo "Compressing files..."

    tar -zcpf "$MAINDIR/$WEBSITE.tar.gz" "$MAINDIR/files"

    echo "Clearing $WEBSITE"

    rm -r $MAINDIR/files

    echo ""
done

echo "Starting remote send..."

/home/klient.dhosting.pl/USER/rclone/rclone copy /home/klient.dhosting.pl/USER/backup/backup skynet:/share/hosting -P

echo "Removing backup..."

rm -r $HOME_DIR/backup/backup/*

echo "Done!"
