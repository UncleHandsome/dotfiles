set nocompatible
set nocp
set cursorline
set number
set bg=dark
set textwidth=120
hi statusline guibg=blue ctermfg=8 guifg=DarkGrey ctermbg=15
"set foldmethod=indent
vnoremap < <gv
vnoremap > >gv

"General
filetype plugin on
filetype indent on
set autoread

"user interface
set so=7
set wildmenu
set hlsearch
set smartcase
set ruler
set cmdheight=2
set hid
set whichwrap+=<,>,h,l
set magic
set noerrorbells
set novisualbell
set incsearch
set ignorecase
set showmatch
set mat=2
set lazyredraw
set smartcase
set noeb vb t_vb=
set tm=500

"coloer and fonts
syn on
set encoding=utf8
set ffs=unix,dos,mac

"files
set nobackup
set nowb
set noswapfile

"text, tab and indent
set expandtab
set smarttab
set sw=4
set ts=4
set lbr
set tw=500
set ai
set si
"set wrap

"hi CursorLine term=none cterm=none ctermbg=none ctermbg=none                    
"au InsertEnter * hi CursorLine term=none cterm=underline                        
"au InsertLeave * hi CursorLine term=none cterm=none ctermbg=none       
