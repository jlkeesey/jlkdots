#!/usr/bin/env bash

DRY_RUN=
#DRY_RUN=--dry-run

cd "$(dirname "${BASH_SOURCE}")/..";

#
# Make sure that we have the latest and greatest.
#
#git pull origin master;

SOURCE=dots
TARGET=~
[ ! -e ${TARGET} ] && mkdir ${TARGET}

function doIt() {
    tar -C ${SOURCE} -c -T ./list -f - | tar -C ${TARGET} -xv
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
