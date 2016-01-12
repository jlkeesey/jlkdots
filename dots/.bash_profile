export DEBUG_PREFIX='@@@'

#
# Just invoke the .bashrc and have all settings there. Technically, somethings like environment
# variables can be set and exported once here to save some processing but in practice, the time
# saved is not worth having to remember which things can go into which place.
#
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
