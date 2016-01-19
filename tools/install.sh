#!/usr/bin/env bash
# Copyright (c) 2015-2016 James Keesey

#
# This script copies the tracked configuration or "dot files" to their respective
# places.
#

#
# Where the dot files directory root is. This script is in the tools/ subdirectory
# of the dot file project so getting the parent of the script's directory should be
# the dot files project root directory.
#
scriptDir=$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)
projectDir=$(cd ${scriptDir}/.. && pwd)

. ${scriptDir}/common.sh

#
# Displays this script's usage message and then exits.
#
function usage() {
    echo ""
    echo "usage: $(basename ${BASH_SOURCE[0]}) [-d] [-f] [-r] [-t targetdir]"
    echo ""
    echo "Installs the configuration (or dot files) in this project to their"
    echo "proper locations. Files are only copied if they have changed as"
    echo "determined by the MD5 hash of the files."
    echo ""
    echo "  -d             turns on debug mode which only echos the commands to be run."
    echo "  -f             forces copying over files that exist--the exiting files will be"
    echo "                 be copied to a backup first."
    echo "  -r             dry-run mode. Does not copy any files."
    echo "  -t targetDir   specifies the home or target directory for this command (defaults"
    echo "                 to the current user's HOME directory)"
    echo ""
    exit 3
}

#
# Copies a file from the dotsDir to the target that does not already exist. Because
# the file does not exist we do not need to back it up.
#
function copyNew() {
    local asset=$1
    local dotsDirAsset=$2
    local targetAsset=$3
    local targetDir=$(dirname ${targetAsset})
    #asset does not exist, can just copy it
    echoStatus "N [new]" "${targetAsset}"
    if [ ! -e "${targetDir}" ]; then
        execute mkdir -p "${targetDir}"
    fi
    execute cp "${dotsDirAsset}" "${targetDir}"
}

#
# Copies the asset after backing up the existing item first.
#
function copyBackup() {
    local asset=$1;
    local dotsDirAsset=$2
    local targetAsset=$3
    if [ "${force}" = true ]; then
        local backupName="${backupDir}/${asset}-$(date +"%F-%R:%S")"
        echoStatus "C [conflict]" "${targetAsset} ${red}(forcing--backup to ${backupDir})"
        local backuptargetDir="${backupDir}/$(dirname ${asset#$HOME/})"
        if [ ! -e "${backuptargetDir}" ]; then
            execute mkdir -p "${backuptargetDir}"
        fi
        execute mv "${targetAsset}" "${backupName}"
        execute cp "${dotsDirAsset}" "${target}"
    else
        echoStatus "C [conflict]" "${targetAsset} ${yellow}(skipping)"
    fi
}

#
# Recursively copies the items in a directory.
#
function copyDirectory() {
    local asset=$1
    local dotsDirAsset=$2
    local targetAsset=$3
    echoStatus ". [dir]" "${targetAsset}"
    #
    # find all files in the given directory without recursing and strip off any
    # leading ./ from the names. It works with them but I don't like how it looks.
    #
    local assets=$(find ${asset} -mindepth 1 -maxdepth 1 -print | sed -e 's!^\./!!g' | xargs)
    install_assets ${assets}
}

#
# Copies an item over an existing item. If the existing item is identical to the new
# one then nothing is copied, otherwise the existing item is backed up before the copy.
#
function copyExisting() {
    local asset=$1
    local dotsDirAsset=$2
    local targetAsset=$3
    targetHash=$(md5prog ${targetAsset})
    dotsDirHash=$(md5prog ${dotsDirAsset})
    if [ ${dotsDirHash} = ${targetHash} ]; then
        echoStatus "S [same]" "${targetAsset}"
    else
        copyBackup ${asset} ${dotsDirAsset} ${targetAsset}
    fi
}

#
# Installs a single asset to the correct location. If the asset is a directory then
# it is recursively processed.
#
function install_asset() {
    local asset=$1
    local dotsDirAsset="${dotsDir}/${asset}"
    local targetAsset="${target}/${asset}"
    if [ -d ${dotsDirAsset} ]; then
        copyDirectory ${asset} ${dotsDirAsset} ${targetAsset}
    elif [ ! -e ${targetAsset} ]; then
        copyNew ${asset} ${dotsDirAsset} ${targetAsset}
    else
        copyExisting ${asset} ${dotsDirAsset} ${targetAsset}
    fi
}

#
# Processes the list of assets and installs them to the correct location.
#
function install_assets() {
    local assets=$*
    echoDebug "assets: [ ${assets} ] "
    for asset in $@; do
        install_asset ${asset}
    done
}

#
# Executes the installation based on the environment settings.
#
function doIt() {
    #
    # Make sure that we have the latest and greatest.
    #
    if [[ "${force}" = true || -z $(git status -s) ]]; then
        execute git pull origin master
    fi

    if [ ! -e ${backupDir} ]; then
        mkdir -p ${backupDir};
    fi

    install_assets "."
}

force=
dryRun=
debug=
target=
dotsDir="${projectDir}/dots"
backupName=".dot.bak"

cd ${dotsDir}

# Fixing installation folder if user is root
if [ $(whoami) = "root" ]; then
    target="/root"
else
    target=$HOME
fi

args=`getopt dfrt: $*`
# you should not use `getopt abo: "$@"` since that would parse
# the arguments differently from what the set command below does.
if [ $? != 0 ]; then
    usage
fi
set -- ${args}
# You cannot use the set command with a backquoted getopt directly,
# since the exit code from getopt would be shadowed by those of set,
# which is zero by definition.
for i; do
    case "$i" in
        -d)
            debug=true
            shift;;
        -f)
            force=true
            shift;;
        -r)
            dryRun=true
            shift;;
        -t)
            target=$2
            shift
            shift;;
        --)
            shift; break;;
    esac
done

backupDir="${target}/${backupName}"

echoDebug "force is" ${force}
echoDebug "debug is" ${debug}
echoDebug "dryRun is" ${dryRun}
echoDebug "target is" ${target}
echoDebug "backup folder is" ${backupDir}
echoDebug "projectDir is" ${projectDir}
echoDebug "dotsDir is" ${dotsDir}
echo ""

doIt
