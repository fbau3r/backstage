#!/bin/bash

backup_drive_name="Backup Container"
veracrypt_drive_letter=T
veracrypt_path="${PROGRAMFILES}/VeraCrypt/veracrypt.exe"

backstage_conf_path="$(realpath "${USERPROFILE}/.backstage/backstage.conf")"
if [[ ! -f "${backstage_conf_path}" ]]; then
    echo -e "\e[31mError\e[0m: Cannot find \"${backstage_conf_path}\""
    exit 10
fi

# load machine.conf from user profile
source "${backstage_conf_path}"

# assert values and given files exist
test    "${backup_name:?}"
test -f "${veracrypt_key_file:?}"   || { echo -e "\e[31mError\e[0m: Cannot find \"$(realpath "${veracrypt_key_file}")\"";   exit 12; }

function waitfor_backup_drive() {
    # wait for mounted backup drive
    while : ; do

        backup_drive=$( powershell -command "Get-WmiObject -Class Win32_Volume -Filter \"Label like '${backup_drive_name}%'\" | %{ \$_.DriveLetter }" )

        if [[ -n "$backup_drive" ]]; then
            # https://unix.stackexchange.com/a/26592/278383
            # Clear everything on the line, regardless of cursor position
            echo -e "\033[2K\r\e[32mInfo\e[0m: Found backup drive \"${backup_drive_name}\" with drive letter \"${backup_drive}\""
            break
        else
            echo -en "\r\e[36mWaiting\e[0m: Please insert backup drive \"${backup_drive_name}\"... (CTRL+C to abort)"
            sleep 5s
        fi

    done

    backup_file="${backup_drive}/${backup_name}"
    if [[ ! -f "${backup_file}" ]]; then
        echo -e "\e[31mError\e[0m: Cannot find \"${backup_file}\" on backup drive"
        exit 101
    fi
}

function mount_backup_volume() {
    echo "Mounting encrypted volume..."
    "${veracrypt_path}" \
        //volume "$(cygpath -w "${backup_file}")" \
        //letter "${veracrypt_drive_letter}" \
        //history n \
        //quit \
        //tryemptypass \
        //keyfile "$(cygpath -w "${veracrypt_key_file}")" \
        || { echo -e "\e[31mError\e[0m: Could not mount encrypted volume"; exit 201; }
}

waitfor_backup_drive
mount_backup_volume

echo "Start backup..."
echo "start macrium backup"

echo "Unmount encrypted volume..."
echo "unmount"

echo "Unmount backup drive..."
echo "unmount"
echo -e "\e[32mDone\e[0m"
