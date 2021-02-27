# shellcheck shell=bash source=/dev/null

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# User specific aliases, environment, and functions

unalias -a
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias irc='ssh blahaj.buttslol.net -l ilianaw -t irc'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias rg='rg --colors path:fg:212 --colors line:fg:141 --colors match:fg:203'
hash python 2>/dev/null || alias python=python3

for dir in ~/.bin ~/.cargo/bin; do
    [[ $PATH != ?(*:)$dir?(:*) && -d $dir ]] && PATH="$dir:$PATH"
done
export PATH

export AWS_SDK_LOAD_CONFIG=1
export EDITOR=vim
if [[ -z $SSH_AUTH_SOCK ]]; then
    SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export SSH_AUTH_SOCK
fi

HISTCONTROL=ignoredups:erasedups
HISTSIZE=50000
HISTTIMEFORMAT="%F %T  "
unset LESSOPEN
unset HISTFILESIZE

# shellcheck disable=SC2046
eval $(dircolors "$HOME"/.dir_colors)

shopt -s checkwinsize histappend

__debug_trap() {
    # shellcheck disable=SC2046
    [[ -n $TMUX ]] && eval $(tmux show-environment -s)
}
trap __debug_trap DEBUG

__prompt_command() {
    local exit=$?

    PS1="\n\[\e[48;5;61;38;5;255m\]${HOSTNAME%.*}\[\e[0m\]"
    if [[ $exit != 0 ]]; then
        PS1+="  \[\e[38;5;203m\]$exit\[\e[0m\]"
    else
        PS1+="  \[\e[38;5;117m\]$exit\[\e[0m\]"
    fi
    PS1+="  \[\e[38:5:228;3m\]\w\[\e[0m\]\n"
    PS1+="\[\e[38;5;61;1m\]\$\[\e[0m\] "
}
PROMPT_COMMAND=__prompt_command
