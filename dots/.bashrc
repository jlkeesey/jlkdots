DEBUG_PROFILE=true
if [ ${DEBUG_PROFILE} = true ]; then
    #set -x
    echo "${DEBUG_PREFIX} .bashrc"
    export BASHRC_SETTINGS=$(set +o)
fi

function sourceIf() {
    local file=$1
    local isExternal=$2
    if [ ${DEBUG_PROFILE} = true ]; then
        local oldPrefix="${DEBUG_PREFIX}"
        export DEBUG_PREFIX="${DEBUG_PREFIX}@"
        echo "${DEBUG_PREFIX} $(basename ${file})"
        if [ ! -z "${isExternal}" ]; then
            set +x
        fi
    fi
    [ -r "${file}" ] && [ -f "${file}" ] && source "${file}";
    if [ ${DEBUG_PROFILE} = true ]; then
        if [ ! -z "${isExternal}" ]; then
            eval "${BASHRC_SETTINGS}"
        fi
        export DEBUG_PREFIX=${oldPrefix}
    fi
}

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH` and  MANPATH.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,exports,path,aliases,functions,extra,completions}; do
    sourceIf ${file}
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;
