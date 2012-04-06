"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"activate pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

if has("gui_running")
	if has("gui_gtk2")
		set guifont=ProggyCleanTTSZ\ for\ Powerline\ 12
	else
		set guifont=Courier\ New:h12
	endif
endif

syntax on

set encoding=utf-8

set nobackup
set noswapfile

set showcmd
set showmode

set noerrorbells
set novisualbell
set vb t_vb=

set hidden
set mouse=a

set autoindent
set copyindent
set smartindent
set smarttab
set smartcase

set showmatch

set nowrap
set backspace=indent,eol,start


set hlsearch
set incsearch
set ignorecase

set history=1000
set undolevels=1000

set number
set ruler

set shiftwidth=4
set tabstop=4
set softtabstop=4
set noexpandtab

set scrolloff=8
set sidescrolloff=7

set autochdir
set shortmess=a
set autoread

set wildmode=longest:full
set wildmenu

set cursorline

"turn on syntax highlighting
syntax on

"load ftplugins and indent files
filetype on
filetype plugin on
filetype indent on

set statusline=%F%m%r%h%w\ [Format:\ %{&ff}]\ [Type:\ %Y]\ [Lines:\ %L\ @\ %p%%\ {%l;%v}]
set laststatus=2

" change the mapleader from \ to ,
let mapleader=","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

let Tlist_WinWidth = 35
let Tlist_Display_Tag_Scope = 1
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Show_One_File = 1
let Tlist_Process_File_Always = 1
let Tlist_Show_Menu = 1

let g:Powerline_symbols = 'fancy'

"Mappings for save and quit
nmap q :q<CR>
nmap Q :q!<CR>
nmap w :w<CR>
nmap W :wq<CR>

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Clean the last search
nmap <silent> <leader>z :nohlsearch<CR>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Underline the current lines with '=' or '-'
nmap <silent> ,u= :t.\|s/./=/g\|:nohls<cr>
nmap <silent> ,u- :t.\|s/./-/g\|:nohls<cr>

" Remap ESC to a better shortcut. I've never type 'jj' anyway
imap jj <ESC>

function! ColorColumnToggle()
	if &colorcolumn
		set colorcolumn=
	else
		set colorcolumn=81
	endif
endfunction
