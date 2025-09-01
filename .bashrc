# shellcheck shell=bash source=/dev/null

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# User specific aliases, environment, and functions

HISTCONTROL=ignoredups:erasedups
HISTSIZE=50000
HISTFILESIZE=
HISTTIMEFORMAT="%F %T  "
shopt -s checkwinsize histappend

homebrew="$(command -v {/opt/homebrew,/usr/local}/bin/brew 2>/dev/null)"
if [[ -n $homebrew ]]; then
    if [[ -z ${HOMEBREW_REPOSITORY+x} ]]; then
        # shellcheck disable=SC2046
        eval $(env -i HOME="$HOME" "$homebrew" shellenv)
    else
        # shellcheck disable=SC2046
        eval $(env -i HOME="$HOME" "$homebrew" shellenv | grep -w PATH=)
    fi
fi
unset homebrew

# tmux-256color terminfo doesn't ship with macOS (or at least didn't in
# Monterey), so load up a terminfo that's patched to work with it.
if [[ $OSTYPE = darwin* ]] && [[ $TERM = tmux-256color ]]; then
    export TERMINFO="$HOME/.local/share/terminfo"
    if ! [[ $TERMINFO/74/tmux-256color -nt $HOME/.config/dotfiles/tmux-256color.terminfo ]] \
            || ! [[ $TERMINFO/74/tmux-256color -nt /usr/bin/tic ]]; then
        mkdir -p "$TERMINFO"
        /usr/bin/tic -x "$HOME/.config/dotfiles/tmux-256color.terminfo"
    fi
fi

# NetBSD doesn't have any system-wide configs that set $PATH and relies on ~/.profile.
# The presence of this bashrc prevents loading ~/.profile.
if [[ $OSTYPE = netbsd ]]; then
    PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R7/bin:/usr/pkg/bin
    PATH+=:/usr/pkg/sbin:/usr/games:/usr/local/bin:/usr/local/sbin
fi

[[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
[[ -x /opt/local/bin/pkgin ]] && PATH="$PATH:/opt/local/sbin:/opt/local/bin"

[[ ! -z ${HOMEBREW_PREFIX+x} ]] && PATH="/opt/homebrew/opt/node@20/bin:$PATH"
[[ ! -z ${HOMEBREW_PREFIX+x} ]] && PATH="/opt/homebrew/opt/python@3.11/bin:$PATH"
PATH="$HOME/.bin:$HOME/.cargo/bin:$HOME/.npm-packages/bin:$HOME/.local/bin:$PATH"
# de-duplicate $PATH
PATH="$(tr : '\n' <<<"$PATH" | awk '!x[$0]++' | tr '\n' : | sed -e 's/:$//')"
export PATH

[[ -f $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
[[ -f /usr/share/bash-completion/bash_completion ]] && . "/usr/share/bash-completion/bash_completion"
[[ -f /usr/pkg/share/bash-completion/bash_completion ]] && . "/usr/pkg/share/bash-completion/bash_completion"

unalias -a

alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
[[ $(type -t __git_complete) = function ]] && __git_complete dotfiles git

command -v python3 >/dev/null 2>&1 && alias python=python3
command -v mpv >/dev/null 2>&1 && alias mpvl='mpv --loop-playlist'
command -v mpv >/dev/null 2>&1 && alias mpvsl='mpv --loop-playlist --shuffle'
command -v weechat >/dev/null 2>&1 && alias weechat='HOSTNAME=$HOSTNAME weechat'

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

if command -v eza >/dev/null 2>&1; then
    alias ls='eza'
    alias ll='eza --long --header'
    alias tree='eza --tree'
fi
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

if [[ -e /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
    alias tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
fi

[[ -f $HOMEBREW_PREFIX/bin/kijetesantakaluotokieni ]] && export ANSIBLE_COW_PATH=$HOMEBREW_PREFIX/bin/kijetesantakaluotokieni
export APPLE_SSH_ADD_BEHAVIOR=openssh
export AWS_SDK_LOAD_CONFIG=1
export DOCKER_SCAN_SUGGEST=false
unset LESS
unset LESSOPEN

FIGNORE=DS_Store

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
