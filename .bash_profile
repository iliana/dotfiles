# shellcheck shell=bash source=/dev/null

# Get the aliases and functions
[[ -f ~/.bashrc ]] && . ~/.bashrc

# User specific startup programs
if [[ -z "$SSH_CONNECTION" && -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -s)"
fi
