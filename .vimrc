filetype plugin indent on
syntax enable

if $TERM ==# 'tmux-256color'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

autocmd SourcePost * hi Normal guibg=NONE ctermbg=NONE
colorscheme catppuccin_mocha

set expandtab
set hlsearch
set number
set numberwidth=4
set shiftwidth=4
set termguicolors
set updatetime=100

packadd sleuth
