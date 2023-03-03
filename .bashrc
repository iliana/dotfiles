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

    if [[ -z $(ls "$HOME/.local/share/terminfo/*/tmux-256color" 2>/dev/null) ]]; then
        mkdir -p "$HOME/.local/share/terminfo"
        /opt/homebrew/opt/ncurses/bin/infocmp -x tmux-256color | sed -e 's/pairs#[x0-9]*,/pairs#32767,/' > "$HOME/.local/share/terminfo/tmux-256color.src"
        /usr/bin/tic -x -o "$HOME/.local/share/terminfo" "$HOME/.local/share/terminfo/tmux-256color.src"
        rm "$HOME/.local/share/terminfo/tmux-256color.src"
    fi
fi
unset homebrew

[[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"

[[ -x /opt/local/bin/pkgin ]] && PATH="$PATH:/opt/local/sbin:/opt/local/bin"

PATH="/opt/homebrew/opt/node@18/bin:$PATH"
PATH="/opt/homebrew/opt/python@3.11/bin:$PATH"
PATH="$HOME/.bin:$HOME/.cargo/bin:$HOME/.npm-packages/bin:$HOME/.local/bin:$PATH"
[[ -d $HOME/git/omicron ]] && PATH="$HOME/git/omicron/out/cockroachdb/bin:$HOME/git/omicron/out/clickhouse:$PATH"
PATH="$(tr : '\n' <<<"$PATH" | awk '!x[$0]++' | tr '\n' : | sed -e 's/:$//')"
export PATH

[[ -f $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
[[ -f /usr/share/bash-completion/bash_completion ]] && . "/usr/share/bash-completion/bash_completion"

unalias -a

alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
[[ $(type -t __git_complete) = function ]] && __git_complete dotfiles git

alias irc='ssh blahaj -t irc'

alias rg='rg --colors path:fg:212 --colors line:fg:141 --colors match:fg:203'

[[ -x /usr/gnu/bin/grep ]] && grepdir=/usr/gnu/bin/
# shellcheck disable=SC2139
alias egrep="${grepdir}egrep --color=auto"
# shellcheck disable=SC2139
alias fgrep="${grepdir}fgrep --color=auto"
# shellcheck disable=SC2139
alias grep="${grepdir}grep --color=auto"
unset grepdir

hash python3 2>/dev/null && alias python=python3
hash mpv 2>/dev/null && alias mpvl='mpv --loop-playlist'
hash mpv 2>/dev/null && alias mpvsl='mpv --loop-playlist --shuffle'

if hash exa 2>/dev/null; then
    alias ls='exa'
    alias ll='exa --long --header'
    alias tree='exa --tree'
else
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
fi
# shellcheck disable=SC2046
eval $(dircolors ~/.dir_colors 2>/dev/null || gdircolors ~/.dir_colors 2>/dev/null || :)

if [[ -e /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
    alias tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
fi

if [[ -d $HOME/git/Kaleidoscope ]] && hash arduino-cli 2>/dev/null; then
    export KALEIDOSCOPE_DIR=$HOME/git/Kaleidoscope
fi

export ANSIBLE_COW_PATH=$HOMEBREW_PREFIX/bin/kijetesantakaluotokieni
export APPLE_SSH_ADD_BEHAVIOR=macos
export AWS_SDK_LOAD_CONFIG=1
export DOCKER_SCAN_SUGGEST=false
export EDITOR=vim
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

# Source host-specific definitions
[[ -f $HOME/.bashrc.local ]] && . "$HOME/.bashrc.local"

true
