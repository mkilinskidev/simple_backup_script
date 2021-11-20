#!/bin/bash

set -ueo pipefail

DATE=$(date +%Y%m%d_%H%M)
HOME_DIR="${HOME}"
RCLONE_PATH="${HOME_DIR}/backup/.rclone"
FILES_PATH="${HOME_DIR}/backup/.temp"
REMOTE_PATH="skynet:/share/TimeMachine/hosting"

printf "[INFO] Starting backup..."
if [ -d "$FILES_PATH" ]; then
    rm -r "$FILES_PATH"
fi

for i in $(cat $HOME_DIR/backup/.config/websites.conf) 
do
    WEBSITE=$(echo $i | awk -F: '{print $1}')
    DATABASE=$(echo $i | awk -F: '{print $2}')
    MAINDIR=$FILES_PATH/$DATE/$WEBSITE

    mkdir -p $MAINDIR/files

    printf "\n[INFO] Compressing $WEBSITE"	
    tar -zcf "$MAINDIR/files/$WEBSITE.tgz" --directory "$HOME_DIR/websites/" "$WEBSITE" 

    if [ -z "$DATABASE" ]; then
        printf "\n[WARN] Database name is empty, skipping"
    else
        printf "\n[INFO] Dumping database ${DATABASE}"
        mysqldump --defaults-extra-file=$HOME_DIR/backup/.config/mysql.cnf $DATABASE > $MAINDIR/files/$WEBSITE.sql
    fi

    printf "\n[INFO] Preparing $WEBSITE to archive"
    tar -zcf "$MAINDIR/$WEBSITE.tgz" --directory "$MAINDIR" "files"

    printf "\n[INFO] Cleanup $WEBSITE"
    rm -r $MAINDIR/files

    echo
done

printf "\n[INFO] Sending files to remote"
$RCLONE_PATH/rclone copy $FILES_PATH $REMOTE_PATH -P

printf "\n[INFO] Cleanup $WEBSITE"
rm -r $FILES_PATH

printf "\n[INFO] Done!"
exit 0
