#!/bin/bash

folder=$(pwd)
error_msg="Install rclone manually and place the binary in ${folder} folder."

exist=$(hash unzip 2>>/dev/null)
if [ "$?" -eq 1 ]; then
    printf "[ERROR] No unzip package found. ${error_msg}"
    echo
    exit
fi

set -ueo pipefail

OS_type="$(uname -m)"
case "$OS_type" in
  x86_64|amd64)
    OS_type='amd64'
    ;;
  i?86|x86)
    OS_type='386'
    ;;
  aarch64|arm64)
    OS_type='arm64'
    ;;
  arm*)
    OS_type='arm'
    ;;
  *)
    echo 'OS type not supported'
    exit 2
    ;;
esac

download_link="https://downloads.rclone.org/rclone-current-linux-${OS_type}.zip"
rclone_zip="rclone-current-linux-${OS_type}.zip"

printf "[INFO] Downloading rclone from ${download_link}"
curl -OfsS "$download_link"

if [ ! -f "$folder/$rclone_zip" ]; then
    printf "\n[ERROR] File cannot be downloaded. ${error_msg}"
    echo
    exit
fi

if [ -d "$folder/.tmp" ]; then
    rm -r "$folder/.tmp"
fi

printf "\n[INFO] Unziping ${rclone_zip}"
rcfolder=$(unzip -a "$rclone_zip" -d ".tmp" | grep "creating" | awk '{print $2}')
if [ ! "$?" -eq 0 ]; then
    printf "\n[ERROR] Something wrong happend while uziping rclone. ${error_msg}"
    echo
    exit
fi

printf "\n[INFO] Installing rclone"
mv "$rcfolder/rclone" "$folder"

printf "\n[INFO] Cleanup"
rm -r "$folder/.tmp"
rm "$folder/$rclone_zip"

printf "\n[INFO] Done!\n"