#!/bin/bash

script_dir="$(realpath $(dirname $0))"

backup_drive_name="Backup Container"
veracrypt_drive_letter=T
veracrypt_path="${PROGRAMFILES}/VeraCrypt/veracrypt.exe"
robocopy_path="${WINDIR}/system32/robocopy.exe"

backstage_conf_path="$(realpath "${USERPROFILE}/.backstage/backstage-storage.conf")"
if [[ ! -f "${backstage_conf_path}" ]]; then
    echo -e "\e[31mError\e[0m: Cannot find \"${backstage_conf_path}\""
    exit 10
fi

# load machine.conf from user profile
source "${backstage_conf_path}"

# assert values and given files exist
test    "${backup_name:?}"
test -f "${veracrypt_key_file:?}"   || { echo -e "\e[31mError\e[0m: Cannot find \"$(realpath "${veracrypt_key_file}")\"";   exit 12; }
test -d "${source_drive_letter:?}/" || { echo -e "\e[31mError\e[0m: Cannot find \"$(realpath "${source_drive_letter}")/\""; exit 12; }

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

function start_backup() {
    echo "Starting backup..."

    run_robocopy "Shared Data" "" "VirtualBox*"                 || return 10
    run_robocopy "Software" "*.iso" "Development"               || return 11
    run_robocopy "Backup" "*.mrimg *.img *.tc *.vc *.backstage" || return 12
    run_robocopy "Mobile"                                       || return 13
    run_robocopy "Shared Music"                                 || return 14
    run_robocopy "Shared Pictures"                              || return 15
    run_robocopy "Shared Videos"                                || return 16
    run_robocopy "Videothek\Filme-Kinder"                       || return 17
    run_robocopy "Videothek\Serien-Kinder"                      || return 18
    # not included intentionally: uTorrent
}

function run_robocopy() {

    echo -e "\e[36mHint\e[0m: Start Backup of directory \"${1:?}\"..."
    "${robocopy_path}" \
        //MIR //B //FFT //R:3 //W:10 //Z //NP //NDL \
        "${source_drive_letter}/${1:?}" "${veracrypt_drive_letter}:/${1:?}" \
        //XF desktop.ini SyncToy_*.dat Thumbs.db *.tmp *.temp ${2} \
        //XD .svn _svn .dthumb .Shared .trash .sync ${3}

    result=$?
    if [ $result -lt 8 ]; then
        echo -e "\e[36mHint\e[0m: Directory backup succeeded..."
        return 0
    else
        echo -e "\e[36mHint\e[0m: Robocopy for directory \"${1:?}\" returned exit code $result"
        echo -e "      \e[1;30mFor details, see http://ss64.com/nt/robocopy-exit.html\e[0m"
        return $result
    fi
}

function start_failure_cleanup() {
    echo; echo -e "\e[33mHint\e[0m: Starting \e[35mFailure Cleanup\e[0m"
}

function done_with_errors() {
    error_code=${1:-1}
    echo -e "\e[31mDone\e[0m (with Errors above)"
    exit $error_code
}

setup_console_title
waitfor_backup_drive   || exit
mount_backup_volume    || exit
start_backup           || { error_code=$?; start_failure_cleanup; unmount_backup_volume; done_with_errors $error_code; }
unmount_backup_volume  || done_with_errors $?
echo -e "\e[32mDone\e[0m"
