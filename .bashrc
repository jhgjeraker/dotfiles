# .bashrc

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
alias ll='ls -lh'
alias la='ls -lah'

alias py='python3'
alias pyinit='source /usr/local/bin/pyenv-init.sh'

# ----------------------------------------------------------------------------
# Development
#
# Golang
export GOPATH=$HOME/dev/go
export PATH="$PATH:$HOME/dev/go/bin"

# Disruptive Technologies
export DT_CREDENTIALS_FILE="$HOME/.config/disruptive/credentials.json"
source '/usr/local/bin/dt-completion.bash'

# Google Cloud
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/dev/google-cloud-sdk/path.bash.inc" ]; then . "$HOME/dev/google-cloud-sdk/path.bash.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/dev/google-cloud-sdk/completion.bash.inc" ]; then . "$HOME/dev/google-cloud-sdk/completion.bash.inc"; fi

# Terraform
export PATH="$HOME/.tfenv/bin:$PATH"

# Kubernetes
source '/usr/local/bin/kubectl-completion.bash'

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --glob "!.git/*" --glob "!node_modules/*" --glob "!vendor/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
