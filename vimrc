" This is the basic vimrc that I will use for whenever vim is available
" Horray for vim!
" Note that in order to use this, we will need to install pathogen
" as well as get the iceberg theme

syntax on
filetype plugin indent on
colorscheme iceberg

set autoindent
set expandtab
set number
set shiftwidth=2
set softtabstop=2
set backup
set noswapfile
set noundofile

" Word Wrapping
set wrap
set linebreak
set nolist  " list disables linebreak
set textwidth=0
set wrapmargin=0
set formatoptions-=t
set backupdir=~/.vim/backup

execute pathogen#infect()

" Vim Plugins

" Vim Markdown Plugin
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Firefox'
