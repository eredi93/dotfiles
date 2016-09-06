" Vundle
" ======
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'shougo/neocomplete.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'vim-ruby/vim-ruby'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-markdown'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'

call vundle#end()            " required
filetype plugin indent on    " required

" Config
" ======
set t_Co=256
set encoding=utf-8
set number
set hidden
set clipboard=unnamed
set rnu

" Map leader
let mapleader=','

let g:Powerline_symbols = 'fancy'
" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Map keys
imap jk <ESC>
" Map shortcut (Ctrl+n) to toggle NerdTree
map <C-n> :NERDTreeToggle<CR>
" Move windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-k> <C-w>l
" Make windows equal
nmap <C-=> <C-w>=
" Move and expand windows
"nmap <C-H> <C-w>h<C-w><Bar>
"nmap <C-J> <C-w>j<C-w><Bar>
"nmap <C-K> <C-w>k<C-w><Bar>
"nmap <C-L> <C-w>l<C-w><Bar>
" Save
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

" Arrows are unvimlike 
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" 80 char line
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" indention
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" lang
autocmd Filetype python setlocal ts=4 sw=4 sts=0 expandtab

" theme
syntax on
"let g:solarized_termcolors=256
colorscheme solarized

try
   let g:airline_powerline_fonts = 1
   set laststatus=2
   let g:airline_theme='powerlineish'
catch                                                                         
endtry

set background=dark

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" custom commands
command ReplaceAllDoubleQuotes :%s/\"\([^"]*\)\"/'\1'/g
command ReplaceAllSingleQuotes :%s/\'\([^']*\)\'/"\1"/g
map csa" :ReplaceAllDoubleQuotes<CR>
map csa' :ReplaceAllSingleQuotes<CR>

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" Notes
:let g:notes_directories = ['~/notes']
:let g:notes_suffix = '.note'

" Neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
