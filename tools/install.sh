#!/usr/bin/env bash
#
# This script copies the tracked configuration or "dot files" to their respective
# places. We do not check if there are

DOTFILES=$(cd $( dirname ${BASH_SOURCE[0]} )/.. && pwd)

#
# Make sure that we have the latest and greatest.
#
#git pull origin master;

#fixing installation folder if user is root
if [ $(whoami) = "root" ];
  then
    TARGET="/root";
  else
    TARGET=$HOME;
fi

SOURCE="${DOTFILES}/dots"
BACKUP_NAME=".dot.bak";
BACKUP_DIR="${TARGET}/${BACKUP_NAME}";

[ ! -e ${BACKUP_DIR} ] && mkdir ${BACKUP_DIR}

#debug=true
#----debug setup----
#home=$1
#gitrepo=$2;
#------------------

function md5prog() {
    if [ $(uname) = "Darwin" ]; then
        md5 -q $1
    fi
    if [ $(uname) = "Linux" ]; then
        md5sum $1 | awk {'print $1'}
    fi
}

function copyNew() {
    local asset=$1;
    local sourceAsset="${SOURCE}/${asset}";
    local targetAsset="${TARGET}/${asset}";
    #asset does not exist, can just copy it
    echo "N [new] ${targetAsset}";
    local recurse=""
    if [ -d ${sourceAsset} ]; then
        recurse=-R;
    fi
    if [ "${debug}" = true ]; then
        echo cp ${recurse} ${sourceAsset} "${TARGET}/$(dirname ${asset})";
    else
        cp ${recurse} ${sourceAsset} "${TARGET}/$(dirname ${asset})";
    fi
}

function copyBackup() {
    local asset=$1;
    local sourceAsset="${SOURCE}/${asset}";
    local targetAsset="${TARGET}/${asset}";
    #asset exist but is different, must back it up
    echo "C [conflict] ${targetAsset}";
    local backupTargetDir="${BACKUP_DIR}/$(dirname ${targetAsset#$HOME/})"
    if [ "${debug}" = true ]; then
        if [ ! -e ${backupTargetDir} ]; then
            echo mkdir -p ${backupTargetDir}
        fi
        echo mv ${targetAsset} ${BACKUP_DIR}/${asset};
        echo cp ${sourceAsset} ${TARGET};
    else
        if [ ! -e ${backupTargetDir} ]; then
            mkdir -p ${backupTargetDir}
        fi
        mv ${targetAsset} ${BACKUP_DIR}/${asset};
        cp ${sourceAsset} ${TARGET};
    fi
}

function install_assets() {
    local assets=$1
    for asset in $@; do
        local sourceAsset="${SOURCE}/${asset}";
        local targetAsset="${TARGET}/${asset}";
        if [ ! -e ${targetAsset} ]; then
            copyNew ${asset}                                      # asset does not exist, can just copy it
        else                                                      # asset is there already
            if [ -d $home/$asset ]; then
                copyNew ${asset}                                  # Dir exists just add to it
            else
                targetHash=$(md5prog ${targetAsset});
                sourceHash=$(md5prog ${sourceAsset});
                if [ ${sourceHash} = ${targetHash} ]; then        # asset is exactly the same
                    echo "S [same] ${targetAsset}";
                else
                    copyBackup ${asset}                           # asset exist but is different, must back it up
                fi
            fi
        fi
    done
}

function doIt() {
    echo "|* debug is" ${debug}
    echo "|* TARGET is" ${TARGET}
    echo "|* backup folder is" ${BACKUP_DIR}
    echo "|* DOTFILES is" ${DOTFILES}
    echo "|* SOURCE is" ${SOURCE}

    if [ ! -e ${BACKUP_DIR} ]; then
        mkdir -p ${BACKUP_DIR};
    fi

    assets=$(cat ${DOTFILES}/list | xargs);
    echo "|* tracking assets: [ {$assets} ] "
    echo ""

    install_assets ${assets}
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
