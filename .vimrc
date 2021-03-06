colorscheme slate

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
set encoding=utf-8
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
set formatoptions+=mB
set wrap
set ws


"line status
set ls=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L
set laststatus=2

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
au FileType c map <F9> :!gcc -finline-functions -Werror -Wextra -pedantic -O2 -lm -lpthread -o %:r<CR>
au FileType cpp map <F9> :!g++ -std=c++11 -finline-functions -Werror -Wextra -pedantic -O2 -lm -lpthread -o %:r<CR>
au FileType c,cpp map <F8> :!./%:r<CR>
au FileType c,cpp map <F5> :w<CR> :make<CR>
set pt=<f7>

" move around tabs. conflict with the original screen top/bottom
" comment them out if you want the original H/L
" go to prev tab 
map <S-H> gT
" go to next tab
map <S-L> gt


set cscopequickfix=s-,c-,d-,i-,t-,e-

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
if has("syntax")
        "set foldmethod=syntax
else
        "set foldmethod=indent
endif

let g:Powerline_symbols = 'unicode'
let g:Powerline_colorscheme = 'solarized256'
let g:Powerline_stl_path_style = 'short'
