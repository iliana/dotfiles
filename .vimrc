filetype plugin indent on
syntax enable

packadd dracula
colorscheme dracula
highlight Normal ctermbg=none

set expandtab
set hlsearch
set number
set numberwidth=4
set shiftwidth=4
set signcolumn=yes
set updatetime=100

packadd sleuth

autocmd FileType caddyfile setlocal tabstop=4
