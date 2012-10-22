runtime! debian.vim
set cul
set nu
set bg=dark
set tw=120
"set foldmethod=indent
" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv
vmap <tab> >gv
vmap <s-tab> <gv

"General
filetype plugin on
filetype indent on
set ar

"user interface
set so=7
set hls
set wmnu
set ru
set ch=2
set hid
set magic
set noeb
set novb
set is
set ic
set sm
set mat=2
set lz
set scs
set noeb vb t_vb=
set tm=500

"coloer and fonts
syn on
set encoding=utf8
set ffs=unix,dos,mac

"files
set nobk
set nowb
set noswf

"text, tab and indent
set et
set sta
set sw=4
set ts=4
set lbr
set tw=500
set ai
set si
"set wrap


"line status
set ls=2
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

map j gj
map k gk

" for C/C++ files
" F9 to compile, F8 to run, F5 to build
au FileType c map <F9> :!gcc -finline-functions -Wall -Wextra -pedantic -O2 -lm -lpthread -o %:r<CR>
au FileType cpp map <F9> :!g++ -std=c++11 -finline-functions -Wall -Wextra -pedantic -O2 -lm -lpthread -o %:r<CR>
au FileType c,cpp map <F8> :!./%:r<CR>
au FileType c,cpp map <F5> :w<CR> :make<CR>

" move around tabs. conflict with the original screen top/bottom
" comment them out if you want the original H/L
" go to prev tab 
map <S-H> gT
" go to next tab
map <S-L> gt



if has("cscope")
    set cscopetag
    set csto=0
    if filereadable("cscope.out")
        cs add cscope.out  
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose  
endif


autocmd Filetype c :set equalprg=indent
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif 
endif
