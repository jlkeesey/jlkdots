#!/usr/bin/env bash
#
# This script copies the tracked configuration or "dot files" from their respective
# places back to the project directory. Because we are copying into a source code
# control directory, there is no need to make a backup when copying over existing
# files. We only copy files that already exist in the dots directory anyway so it
# definitely makes sense to not worry about it.
#

#
# Where the dot files directory root is. This script is in the tools/ subdirectory
# of the dot file project so getting the parent of the script's directory should be
# the dot files project root directory.
#
projectDir=$(cd $( dirname ${BASH_SOURCE[0]} )/.. && pwd)

#
# Displays this script's usage message and then exits.
#
function usage() {
    echo ""
    echo "usage: $(basename ${BASH_SOURCE[0]}) [-d] [-f] [-s sourcedir]"
    echo ""
    echo "Retrieves the configuration (or dot files) in this project from their"
    echo "proper locations. Files are only copied if they have changed as"
    echo "determined by the MD5 hash of the files."
    echo ""
    echo "  -d             turns on debug mode which only echos the commands to be run."
    echo "  -f             turns off prompting for replacing files (force)."
    echo "  -s sourceDir   specifies the home or source directory for this command (defaults"
    echo "                 to the current user's HOME directory)"
    echo ""
    exit 3
}

#
# Run MD5 against a file to get a hash to use to check if a file has changed.
#
function md5prog() {
    if [ $(uname) = "Darwin" ]; then
        md5 -q $1
    fi
    if [ $(uname) = "Linux" ]; then
        md5sum $1 | awk {'print $1'}
    fi
}

#
# Writes a debuf message.
#
function echoDebug() {
    if [ "${debug}" = true ]; then
        if [[ -z "$*" ]]; then
            echo ""
        else
            echo "${colorDebug}  >> $*${colorReset}"
        fi
    fi
}

#
# Writes out a status message for an item.
#
function echoStatus() {
    echo "${colorStatus}$1 ${colorText}$2${colorReset}"
}

#
# Execute a command optionally displaying it first.
#
function execute() {
    local cmd=$*
    if [ "${debug}" = true ]; then
        echoDebug ${cmd}
    fi
    if [[ "${force}" = true || "${debug}" != true ]]; then
        eval ${cmd}
    fi
}

#
# Recursively copies the items in a directory.
#
function copyDirectory() {
    local asset=$1
    local dotsAsset=$2
    local homeAsset=$3
    echoStatus ". [dir]" "${homeAsset}"
    local assets=$(find ${asset} -mindepth 1 -maxdepth 1 -print | xargs)
    retrieveAssets ${assets}
}

#
# Copies an item over an existing item. If the existing item is identical to the new
# one then nothing is copied, otherwise the existing item is backed up before the copy.
#
function copyExisting() {
    local asset=$1
    local dotsAsset=$2
    local homeAsset=$3
    local dotsAssetDir=$(dirname ${dotsAsset})
    homeHash=$(md5prog ${homeAsset})
    dotsDirHash=$(md5prog ${dotsAsset})
    if [ ${dotsDirHash} == ${homeHash} ]; then
        echoStatus "S [same]" "${homeAsset}"
    else
        echoStatus "C [changed]" "${homeAsset}"
        execute cp "${homeAsset}" "${dotsAssetDir}"
    fi
}

#
# Installs a single asset to the correct location. If the asset is a directory then
# it is recursively processed.
#
function retrieveAsset() {
    local asset=$1
    local dotsAsset="${dotsDir}/${asset}"
    local homeAsset="${home}/${asset}"
    if [ -d ${dotsAsset} ]; then
        copyDirectory ${asset} ${dotsAsset} ${homeAsset}
    elif [ -e ${homeAsset} ]; then
        copyExisting ${asset} ${dotsAsset} ${homeAsset}
    else
        echoStatus "M [missing]" "${homeAsset}"
    fi
}

#
# Processes the list of assets and retrieves them from the correct location.
#
function retrieveAssets() {
    local assets=$*
    echoDebug "assets: [ ${assets} ] "
    for asset in $@; do
        retrieveAsset ${asset}
    done
}

#
# Executes the installation based on the environment settings.
#
function doIt() {
    retrieveAssets "."
}

normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
cyan=$(tput setaf 6)

colorReset=${normal}
colorText=${normal}
colorStatus=${green}
colorDebug=${cyan}
colorError=${red}

force=
debug=
home=
dotsDir="${projectDir}/dots"
backupName=".dot.bak"

cd ${dotsDir}

# Fixing installation folder if user is root
if [ $(whoami) = "root" ]; then
    home="/root"
else
    home=$HOME
fi

args=`getopt dfs: $*`
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
        -s)
            home=$2
            shift
            shift;;
        --)
            shift; break;;
    esac
done

backupDir="${home}/${backupName}"

echoDebug "force is" ${force}
echoDebug "debug is" ${debug}
echoDebug "home is" ${home}
echoDebug "backup folder is" ${backupDir}
echoDebug "projectDir is" ${projectDir}
echoDebug "dotsDir is" ${dotsDir}
echo ""

doIt
