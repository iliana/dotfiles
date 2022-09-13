#!/usr/bin/env bash
set -euxo pipefail
mapfile -t exts <"$HOME/.config/dotfiles/vscode-extensions.txt"
for ext in "${exts[@]}"; do
    code --install-extension "$ext"
done
