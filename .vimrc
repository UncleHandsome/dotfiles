set nocompatible
set nocp
set cursorline
set number
set bg=dark
set textwidth=120
set laststatus=2
"hi statusline guibg=blue ctermfg=8 guifg=DarkGrey ctermbg=15
"set statusline=\ %F%m%r%y[%{strlen(&fenc)?&fenc:&enc}]%h%w%=[%l,%3v]\ --%p%%--\ \  
"hi  statusline ctermfg=DarkGrey ctermbg=blue
"set foldmethod=indent
" allow multiple indentation/deindentation in visual mode
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

"status linec
set laststatus=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction

set matchpairs+=<:>

" for C/C++ files
" F9 to compile, F8 to run, F5 to build
au FileType c map <F9> :!gcc -std=c99 -finline-functions -Wall -Wextra -pedantic -O2 -lm -o -lpthread %:r<CR>
au FileType cpp map <F9> :!g++ -std=c++11 -finline-functions -Wall -Wextra -pedantic -O2 % -lm -o %:r<CR>
au FileType c,cpp map <F8> :!./%:r<CR>
au FileType c,cpp map <F5> :w<CR> :make<CR>

" move around tabs. conflict with the original screen top/bottom
" comment them out if you want the original H/L
" go to prev tab 
map <S-H> gT
" go to next tab
map <S-L> gt
