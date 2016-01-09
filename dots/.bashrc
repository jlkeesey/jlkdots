export DEV=~/Development

export JAVA_VERSION=1.8.0_60
export JAVA_HOME=`/usr/libexec/java_home -v $JAVA_VERSION`

alias ls="ls -aF"
alias md=mkdir
alias cls=clear

alias startsel='webdriver-manager --seleniumPort 4445 start'
alias master="git checkout master"
alias gitb="git branch"
alias gitl="git log --pretty=oneline --abbrev-commit"
alias gits="git status -sb"
alias gb="git branch"
alias gs="git status"
alias gd='git diff HEAD^1..HEAD'
alias gca='git commit --amend'
alias gpp='git pull --rebase && git push'
alias gmf='git merge --ff-only'
alias gls="git log --graph --pretty=format:'%C(cyan)%h%C(red)%d%Creset %s %C(yellow)- %an,%C(magenta) %ar%Creset'"

alias splitpath='echo "$PATH" | tr ":" "\n"'

alias fix="git mergetool -y"
#alias listfiles="git show --pretty='format:' --name-status | sort -u -k2"

function listfiles() {
   git show --pretty='format:' --name-status $* | sort -u -k2 
}

## These next two make the prompt really slow. Too bad.
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWCOLORHINTS=true

export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTREAM=verbose

source ~/.git-prompt.sh
source ~/.git-completion.sh

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

function git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
# \newline\green\user@\host\purple\function\yellow\workingdirectory\white\newline\$
# export PS1="\n\[\e[32m\]\u@\h\[\e[35m\]\$(git_branch) \[\e[33m\]\w\[\e[0m\]\n\$ "
#export PS1="\n\[\e[35m\]\$(git_branch) \[\e[33m\]\w\[\e[0m\] \$ "

#export PROMPT_COMMAND='__git_ps1 "\n\[\e[35m\]" " \[\e[33m\]\w \[\e[0m\]$ "'
export PROMPT_COMMAND='__git_ps1 "\n" " \[\e[35m\]\w \[\e[0m\]$ "'

export PATH="$HOME/bin:/usr/local/packer:$ORIGINAL_PATH::/opt/local/bin:/opt/local/sbin:"

export VAGRANT_BRIDGE='en0: Wi-Fi (AirPort)'


export NPM_PACKAGES="/Users/JamesKeesey/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
