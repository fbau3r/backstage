#!/bin/bash

script_dir="$(realpath $(dirname $0))"

backup_drive_name="Backup Container"
reflect_path="${PROGRAMFILES}/Macrium/Reflect/Reflect.exe"
removedrive_path="${script_dir}/lib/removedrive.exe"
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
test -f "${reflect_profile_path:?}" || { echo -e "\e[31mError\e[0m: Cannot find \"$(realpath "${reflect_profile_path}")\""; exit 11; }
test -f "${veracrypt_key_file:?}"   || { echo -e "\e[31mError\e[0m: Cannot find \"$(realpath "${veracrypt_key_file}")\"";   exit 12; }

function setup_console_title() {
    # https://superuser.com/a/886247/652258
    export PS1="\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n$ "
    echo -ne "\e]0;Backstage\a"
}

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
        return 13
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
        || { echo -e "\e[31mError\e[0m: Could not mount encrypted volume"; return 14; }
}

function unmount_backup_volume() {
    echo "Unmounting encrypted volume..."
    "${veracrypt_path}" \
        //dismount "${veracrypt_drive_letter}" \
        //quit \
        || { echo -e "\e[31mError\e[0m: Could not unmount encrypted volume"; return 31; }
}

function remove_previous_backup() {
    echo "Remove previous backup..."
    reflect_profile_filename=$( \
        cat "$reflect_profile_path" \
        | grep -o -E '<file_name>(.*?)</file_name>' \
        | sed -E 's|<file_name>(.*?)</file_name>|\1|'\
        )

    find "${veracrypt_drive_letter}:/" \
        -maxdepth 1 \
        -type f \
        -name "${reflect_profile_filename}*.mrimg" \
        -delete
}

function start_backup() {
    echo "Starting backup..."
    "${reflect_path}" -e -w -full "${reflect_profile_path}" \
    || {
        echo -e "\e[31mError\e[0m: Could not start backup"
        echo -e "       Please start \e[36mMacrium Reflect\e[0m and check for errors in \e[36mLog\e[0m tab."
        return 21
    }
}

function start_failure_cleanup() {
    echo; echo -e "\e[33mHint\e[0m: Starting \e[35mFailure Cleanup\e[0m"
}

function done_with_errors() {
    error_code=${1:-1}
    echo -e "\e[31mDone\e[0m (with Errors above)"
    exit $error_code
}

function unmount_backup_drive() {
    echo "Unmounting drive \"${backup_drive}\"..."
    "${removedrive_path}" "${backup_drive}" -l -b \
    || { echo -e "\e[31mError\e[0m: Could not unmount drive \"${backup_drive}\""; return 32; }
}

setup_console_title
waitfor_backup_drive   || exit
mount_backup_volume    || exit
remove_previous_backup
start_backup           || { error_code=$?; start_failure_cleanup; unmount_backup_volume; done_with_errors $error_code; }
unmount_backup_volume  || done_with_errors $?
unmount_backup_drive   || done_with_errors $?
echo -e "\e[32mDone\e[0m"
