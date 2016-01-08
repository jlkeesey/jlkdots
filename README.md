# Dotfiles for James Keesey ([@jlkeesey](http://twitter.com/jlkeesey))

These are the configuration dotfiles used by jlkeesey.

## Structure

archive/
 
: This folder contains items that are no longer used but we want to retain just in case. At some point they will be removed when we are sure that they are not needed. This directory will not be copied to the HOME directory.

todo/

: This folder contains items that are in progress or have not yet been processed. Eventually they will be copied to the parent directory. This directory is not copied to the HOME directory.

bin/

: Common commands and scripts.

install.sh

: Script to copy all of the dotfiles to their respective locations.

refresh.sh

: Script to copy all of the dotfiles from their respective locations back to this directory so that GIT can be updated.
 
## Installation

Do something.


### Sources

This is based on a combination of the dotfiles from https://bitbucket.org/durdn/cfg/src and https://github.com/mathiasbynens/dotfiles.
