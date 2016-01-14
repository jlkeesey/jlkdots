#!/usr/bin/env bash
#
# This script contains common code for the other scripts.
#


normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
cyan=$(tput setaf 6)

colorReset=${normal}
colorText=${normal}
colorStatus=${green}
colorDebug=${cyan}
colorError=${red}

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
# Writes a debug message.
#
# $* all arguments are wrtten to the same line
#
function echoDebug() {
    if [ "${debug}" = true ]; then
        if [[ -z "$*" ]]; then
            echo ""
        else
            echo "${colorDebug}  $*${colorReset}"
        fi
    fi
}

#
# Writes out a status message for an item.
#
# $1  the short status
# $2  the item name
#
function echoStatus() {
    echo "${colorStatus}$1 ${colorText}$2${colorReset}"
}

#
# Execute a command optionally displaying it first.
#
# $*  the command line including its parameters
#
function execute() {
    local cmd=$*
    if [ "${debug}" = true ]; then
        echoDebug ${cmd}
    fi
    if [[ "${dryRun}" != true ]]; then
        eval ${cmd}
    fi
}
