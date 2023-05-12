# shellcheck shell=bash source=/dev/null

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# User specific aliases, environment, and functions

homebrew="$(command -v {/opt/homebrew,/usr/local}/bin/brew 2>/dev/null)"
if [[ -n $homebrew ]]; then
    if [[ -z ${HOMEBREW_REPOSITORY+x} ]]; then
        # shellcheck disable=SC2046
        eval $(env -i "$homebrew" shellenv)
    else
        # shellcheck disable=SC2046
        eval $(env -i "$homebrew" shellenv | grep -w PATH=)
    fi
fi
unset homebrew

if [[ $OSTYPE = darwin* ]] && [[ $TERM = tmux-256color ]]; then
    export TERMINFO="$HOME/.local/share/terminfo"
    if ! [[ -f $TERMINFO/tmux-256color.terminfo ]]; then
        mkdir -p "$TERMINFO"
        "$HOMEBREW_PREFIX/opt/ncurses/bin/infocmp" -x tmux-256color > "$TERMINFO/tmux-256color.terminfo"
        /usr/bin/tic -x "$TERMINFO/tmux-256color.terminfo"
    fi
fi

[[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
[[ -x /opt/local/bin/pkgin ]] && PATH="$PATH:/opt/local/sbin:/opt/local/bin"

PATH="/opt/homebrew/opt/node@18/bin:$PATH"
PATH="/opt/homebrew/opt/python@3.11/bin:$PATH"
PATH="$HOME/.bin:$HOME/.cargo/bin:$HOME/.npm-packages/bin:$HOME/.local/bin:$PATH"
PATH="$(tr : '\n' <<<"$PATH" | awk '!x[$0]++' | tr '\n' : | sed -e 's/:$//')"
export PATH

[[ -f $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
[[ -f /usr/share/bash-completion/bash_completion ]] && . "/usr/share/bash-completion/bash_completion"

unalias -a

alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
[[ $(type -t __git_complete) = function ]] && __git_complete dotfiles git

[[ $TERM = "xterm-kitty" ]] && alias ssh='TERM=tmux-256color ssh'
alias irc='ssh blahaj -t irc'

[[ -x /usr/gnu/bin/grep ]] && grepdir=/usr/gnu/bin/
# shellcheck disable=SC2139
alias egrep="${grepdir}egrep --color=auto"
# shellcheck disable=SC2139
alias fgrep="${grepdir}fgrep --color=auto"
# shellcheck disable=SC2139
alias grep="${grepdir}grep --color=auto"
unset grepdir

command -v python3 >/dev/null 2>&1 && alias python=python3
command -v mpv >/dev/null 2>&1 && alias mpvl='mpv --loop-playlist'
command -v mpv >/dev/null 2>&1 && alias mpvsl='mpv --loop-playlist --shuffle'

# There's not a good heuristic for detecting truecolor support for me. On
# desktop I am almost certainly using kitty -> tmux, which works fine (kitty
# sets COLORTERM=truecolor); once I ssh somewhere that environment is lost. But
# I also use Prompt on my phone, which does not support truecolor.
#
# Our heuristic will be "if we've connected via ssh and our TERM is tmux-
# 256color, assume truecolor support".
if [[ -n $SSH_CONNECTION ]] && [[ $TERM = tmux-256color ]]; then
    export COLORTERM=truecolor
fi

if command -v exa >/dev/null 2>&1; then
    alias ls='exa'
    alias ll='exa --long --header'
    alias tree='exa --tree'
else
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
fi
if command -v bat >/dev/null 2>&1; then
    alias cat=bat
fi
if command -v vivid >/dev/null 2>&1; then
    LS_COLORS=$(vivid generate catppuccin-mocha)
else
    LS_COLORS=$(< ~/.config/dotfiles/vivid.out)
fi
export LS_COLORS

if command -v hx >/dev/null 2>&1; then
    export EDITOR=hx
    alias vim=hx
else
    export EDITOR=vim
fi

if [[ -e /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
    alias tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
fi

if [[ -d $HOME/git/Kaleidoscope ]] && command -v arduino-cli >/dev/null 2>&1; then
    export KALEIDOSCOPE_DIR=$HOME/git/Kaleidoscope
fi

export ANSIBLE_COW_PATH=$HOMEBREW_PREFIX/bin/kijetesantakaluotokieni
export APPLE_SSH_ADD_BEHAVIOR=openssh
export AWS_SDK_LOAD_CONFIG=1
export DOCKER_SCAN_SUGGEST=false
unset LESSOPEN

FIGNORE=DS_Store
HISTCONTROL=ignoredups:erasedups
HISTSIZE=50000
HISTTIMEFORMAT="%F %T  "
unset HISTFILESIZE
shopt -s checkwinsize histappend

__debug_trap() {
    # shellcheck disable=SC2046
    [[ -n $TMUX ]] && eval $(tmux show-environment -s)
}
trap __debug_trap DEBUG

__prompt_command() {
    local exit=$?

    PS1="\n\[\e[48;2;30;30;46m\]\[\e[K\]"
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
