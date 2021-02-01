# shellcheck shell=bash source=/dev/null

# Get the aliases and functions
[[ -f ~/.bashrc ]] && . ~/.bashrc

# User specific startup programs

if [[ -z $SSH_CLIENT && ( -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ) && -x /usr/bin/ssh-agent ]]; then
    # shellcheck disable=SC2046
    eval $(/usr/bin/ssh-agent -s) >/dev/null
fi
