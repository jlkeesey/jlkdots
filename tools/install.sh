#!/usr/bin/env bash

DRY_RUN=
DRY_RUN=--dry-run

cd "$(dirname "${BASH_SOURCE}")/..";

#
# Make sure that we have the latest and greatest.
#
git pull origin master;

EXCLUDES=./tools/excludes.txt

SOURCE=dots
TARGET=~/dot-test
mkdir ${TARGET}

function doIt() {
	rsync ${DRY_RUN} --excludeFile "${EXCLUDES}" -avh --no-perms ${SOURCE} ${TARGET};
	#
	# Not sure about this as it only affects the current terminal it could create
	# a false sense that thigs are changed.
	#
	source ~/.bash_profile;
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
