#!/bin/bash

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

unset rc


# ----------------------------------------------------------------------------
# PS1
#
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ (\1)/'
}
export PS1='\[\033[01;32m\]>> \[\033[00m\]\[\033[01;34m\]\W\[\033[01;32m\]$(parse_git_branch)\[$(tput sgr0)\]: '


# ----------------------------------------------------------------------------
# Custom Functions
#
# Quick usage-lookup of any tool directly in the terminal.
# Example: `>> cheat sed`
function cheat() {
    curl "http://cheat.sh/$1"
}


# ----------------------------------------------------------------------------
# Aliases
#
alias pyinit="source /$HOME/.local/bin/pyenv-init.sh"


# ----------------------------------------------------------------------------
# Application Specific
#
# Ranger
export RANGER_LOAD_DEFAULT_RC=FALSE
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --glob "!.git/*" --glob "!node_modules/*" --glob "!vendor/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kepler/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/kepler/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kepler/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/kepler/Downloads/google-cloud-sdk/completion.bash.inc'; fi

export PATH="$HOME/.tfenv/bin:$PATH"
