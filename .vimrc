filetype plugin indent on
syntax enable

set expandtab
set hlsearch
set number
set numberwidth=4
set shiftwidth=4
set termguicolors
set updatetime=100

packadd sleuth
packadd catppuccin

autocmd SourcePost * hi Normal guibg=NONE ctermbg=NONE
colorscheme catppuccin_mocha
