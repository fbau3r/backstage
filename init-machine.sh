#!/bin/bash

script_dir="$(realpath $(dirname $0))"

mkdir -p $(realpath "${USERPROFILE}/.backstage")

backstage_conf_path="$(realpath "${USERPROFILE}/.backstage/backstage.conf")"
if [[ -f "${backstage_conf_path}" ]]; then
    echo -e "\e[31mError\e[0m: Destination path \"${backstage_conf_path}\" already exists."
    echo    "       Will not initialize again"
    exit 10
fi

cp --no-clobber "${script_dir}/backstage.conf.sample" "${backstage_conf_path}"

explorer /select,"$(cygpath -w "${backstage_conf_path}")" &

echo -e "\e[32mInitialized machine\e[0m"
echo "Please review values in \"${backstage_conf_path}\" and"
echo " add corresponding key files to directory if applicable"
