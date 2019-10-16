# Copyright (c) 2015-2016 James Keesey

export DEBUG_PREFIX='@@@'

#
# Just invoke the .bashrc and have all settings there. Technically, somethings like environment
# variables can be set and exported once here to save some processing but in practice, the time
# saved is not worth having to remember which things can go into which place.
#
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/JamesKeesey/gcloud/google-cloud-sdk/path.bash.inc' ]; then source '/Users/JamesKeesey/gcloud/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/JamesKeesey/gcloud/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/JamesKeesey/gcloud/google-cloud-sdk/completion.bash.inc'; fi
