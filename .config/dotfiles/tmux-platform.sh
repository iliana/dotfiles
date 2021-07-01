# shellcheck shell=bash

if [[ $TERMINFO == /Applications/kitty.app/* ]]; then
    tmux set-option -g default-terminal xterm-kitty
fi
