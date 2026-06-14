# shellcheck shell=bash source=/dev/null

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# User specific aliases, environment, and functions

HISTCONTROL=ignoredups:erasedups
HISTSIZE=50000
HISTFILESIZE=
HISTTIMEFORMAT="%F %T  "
shopt -s checkwinsize histappend

# NetBSD doesn't have any system-wide configs that set $PATH and relies on ~/.profile.
# The presence of this bashrc prevents loading ~/.profile.
if [[ $OSTYPE = netbsd ]]; then
    PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R7/bin:/usr/pkg/bin
    PATH+=:/usr/pkg/sbin:/usr/games:/usr/local/bin:/usr/local/sbin
fi

[[ -f /usr/share/bash-completion/bash_completion ]] && . "/usr/share/bash-completion/bash_completion"

unalias -a

alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
[[ $(type -t __git_complete) = function ]] && __git_complete dotfiles git

command -v mpv >/dev/null 2>&1 && alias mpvl='mpv --loop-playlist'
command -v mpv >/dev/null 2>&1 && alias mpvsl='mpv --loop-playlist --shuffle'

# On most of my systems I have added `AcceptEnv COLORTERM` and configured my SSH
# clients to send COLORTERM. For systems where I use my dotfiles but don't have
# control over the system, we use a simple heuristic: "if we've connected via
# SSH and our TERM is tmux-256color, assume truecolor support".
if [[ -z $COLORTERM ]] && [[ -n $SSH_CONNECTION ]] && [[ $TERM = tmux-256color ]]; then
    export COLORTERM=truecolor
fi

alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
# regenerate this with:
# $ vivid generate catppuccin-mocha > ~/.config/dotfiles/vivid.out
# $ vivid -m 8-bit generate catppuccin-mocha > ~/.config/dotfiles/vivid.8.out
if [[ $COLORTERM = truecolor ]]; then
    LS_COLORS=$(< ~/.config/dotfiles/vivid.out)
else
    LS_COLORS=$(< ~/.config/dotfiles/vivid.8.out)
fi
export LS_COLORS

if command -v helix >/dev/null 2>&1; then
    alias hx=helix
fi
if command -v vim >/dev/null 2>&1 && command -v hx >/dev/null 2>&1; then
    function vim() {
        >&2 echo '-bash: vim: fix your muscle memory'
        return 127
    }
fi

export AWS_SDK_LOAD_CONFIG=1
export DOCKER_SCAN_SUGGEST=false
unset LESS
unset LESSOPEN

__debug_trap() {
    # shellcheck disable=SC2046
    [[ -n $TMUX ]] && eval $(tmux show-environment -s)
}
trap __debug_trap DEBUG

__prompt_command() {
    local exit=$?

    PS1="\n\[\e[48;2;24;24;37m\]\[\e[K\]"
    PS1+="\[\e[38;2;137;180;250m\]${HOSTNAME%.*}\[\e[39m\]"
    if [[ $exit != 0 ]]; then
        PS1+="  \[\e[38;2;235;160;172m\]$exit\[\e[39m\]"
    else
        PS1+="  \[\e[38;2;166;227;161m\]$exit\[\e[39m\]"
    fi
    PS1+="  \[\e[38;2;245;224;220;3m\]\w"
    # newline, clear the line, move the cursor up, and newline again
    # this ensures the shell does not clear the line when redrawing the prompt line
    PS1+="\n\[\e[0m\]\[\e[K\]\[\e[F\]\n"
    PS1+="\[\e[38;2;180;190;254m\]\$\[\e[0m\] "
}
PROMPT_COMMAND=__prompt_command

# Source host-specific definitions
[[ -f $HOME/.bashrc.local ]] && . "$HOME/.bashrc.local"

true
