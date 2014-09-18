set nocompatible

let g:dotvim = fnamemodify($MYVIMRC, ':h')
let g:mapleader="\<Space>"

call plug#begin()
let g:plug_window = 'tabnew'

Plug 'vheon/vim-colors-solarized'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'

" XXX: do I relly need this plugin? I have to type the closing brackets anyway
" to jump them so why not type them to close them?
Plug 'vheon/delimitMate', { 'branch': 'fix-abbr-pumvisible', 'on': [] }
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
augroup load_delimitmate
  autocmd!
  autocmd! InsertEnter * call plug#load('delimitMate') | autocmd! load_delimitmate
augroup END

Plug 'tpope/vim-endwise'
let g:endwise_abbreviations = 1
let g:endwise_no_mappings = 1

Plug 'Valloric/ListToggle'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rsi'

" TextObj-User
Plug 'kana/vim-textobj-user'
Plug 'thinca/vim-textobj-function-javascript'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-help'

Plug 'machakann/vim-textobj-delimited'
Plug 'PeterRincker/vim-argumentative'

Plug 'bronson/vim-visual-star-search'
Plug 'tommcdo/vim-lion'
Plug 'tommcdo/vim-exchange'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/inline_edit.vim'
Plug 'AndrewRadev/linediff.vim'

function! YCMInstall(info)
  if a:info.status == 'installed'
    !./install.sh --clang-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': function('YCMInstall') }
let g:ycm_confirm_extra_conf    = 0
let g:ycm_global_ycm_extra_conf = g:dotvim.'/ycm.py'
let g:ycm_extra_conf_vim_data   = ['&filetype']
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_enable_diagnostic_signs = 0
augroup load_ycm
  autocmd!
  autocmd! InsertEnter * call plug#load('YouCompleteMe')
                      \| if exists('g:loaded_youcompleteme')
                      \|   call youcompleteme#Enable()
                      \| endif
                      \| autocmd! load_ycm
augroup END

" XXX: take a deeper look a make a new one from scratch for YCM integration
Plug 'vheon/vimomni.vim'
Plug 'tpope/vim-scriptease'

Plug 'tpope/vim-dispatch'
Plug 'adimit/prolog.vim'

" XXX: I would prefer using it with YouCompleteMe
" Plug '$GOPATH/src/github.com/nsf/gocode', { 'rtp': 'vim/' }

Plug 'Valloric/MatchTagAlways'
" XXX: I should use something a little more generic. See gary bernhardt setup
" Plug 'thoughtbot/vim-rspec'
" let g:rspec_command = "!rspec --color {spec}"

" XXX: note to self for using eclim and putting it inside the plugged
" directory
" Plug g:plug_home.'/eclim'

Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_column_always = 1
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

function! GoBinsInstall(info)
  GoUpdateBinaries
endfunction
Plug 'fatih/vim-go', { 'do': function('GoBinsInstall')}

" XXX: consider to switch back to single plugin for the language that I use
Plug 'vheon/vim-polyglot'
let g:scala_use_default_keymappings = 0
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

call plug#end()

runtime! macros/matchit.vim
runtime plugin/sensible.vim

" In the standart runtime there's a filetype.vim that can handle file.m either
" as matlab file or as objc file if the file is not empty. On empty file it
" fallback to g:filetype_m if specified or 'matlab'
let g:filetype_m = 'objc'

" Set them in this order to avoid sourcing color/solarized.vim more than one
set t_Co=16
set background=dark
colorscheme solarized

set encoding=utf-8

set showmatch
set completeopt-=preview
set completeopt+=menuone
set pumheight=30

set cindent
set cinoptions=L0,g0,N-s,t0,(0
set shiftround

set timeoutlen=500
set updatetime=500

set lazyredraw
set smartcase
set ignorecase

if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
endif

" Mode cursor
" XXX: should I extract it in a plugin?
"      if !has('gui_running')
"        let &statusline .= '%{Mode_cursor()}'
"      else
"        " Setup 'guicursor' with the same colors
"      endif
"
" Change the color of the cursor based on the mode we're in.
" Idea stolen from http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
" He uses the 'guicursor' option which it's for GUI, MSDOW and Win32 console only
" but I use terminal vim on iTerm2 only at the moment so I send escape keys to
" iTerm2 to change the cursor color. The colors are in the form of '#rrggbb'
" because iTerm2 expect 'rrggbb', I put the '#' in there to prevent me to support
" eventually other terminal emulator that use 256 colors or 16 colors.
let s:cursor_mode_color_map = {
      \   "n":      "#839496",
      \   "i":      "#268bd2",
      \   "v":      "#cb4b16",
      \   "V":      "#b58900",
      \   "\<C-V>": "#6c71c4",
      \ }

let s:last_mode = ''
let s:color_template = '"%s\033]Pl%s\033\\"'
let s:cursor_mode_prefix = exists('$TMUX') ? '\033Ptmux;\033' : ''
function! Mode_cursor()
  let mode = mode()
  if mode !=# s:last_mode
    let s:last_mode = mode
    if has_key(s:cursor_mode_color_map, mode)
      try
        let save_ei = &eventignore
        set eventignore="all"
        let escape = substitute(s:cursor_mode_color_map[mode], '^#', '', '')
        execute 'silent! !printf' printf(s:color_template, s:cursor_mode_prefix, escape)
      finally
        let &eventignore = save_ei
      endtry
    endif
  endif
  return ''
endfunction

let &statusline  = has('gui_running') ? '' : '%{Mode_cursor()}'
let &statusline .= '%h%w '
let &statusline .= '%<%f '
let &statusline .= '%{fugitive#statusline()}'
let &statusline .= '%-4(%m%r%)'
let &statusline .= '%='
let &statusline .= '%y '
let &statusline .= '%-14(%P %3l:%02c%)'
let &statusline .= '[%{strlen(&l:fenc) ? &enc : &l:fenc}]'
set cmdheight=2
set noshowmode
set wildmode=list:longest
set wildignore+=.hg,.git,.svn
set wildignore+=*.o,*.obj,*~
set wildignore+=*.DS_Store
set wildignore+=*.png,*.jpg,*.jpeg,*.gif
set wildignore+=*.mkv,*.avi
set wildignore+=*.pyc
set wildignore+=*.class

set nomore

set noautochdir
set hidden
set cursorline
set colorcolumn=81

set viminfo=!,'10,<50,s20,h

set noerrorbells
set novisualbell
set t_vb=

" Prevent Vim from clobbering the scroll back buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

set noswapfile
set nobackup
set nowritebackup

if v:version + has('patch541') >= 704
  set formatoptions+=j
endif
set formatoptions-=oa

set nofoldenable
set foldlevelstart=99
set foldminlines=5
set foldmethod=manual

set list
let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
let &showbreak = "\u21aa "

if has('mouse')
  set mouse=a
endif

" Sudo write
command! W exec 'w !sudo tee % > /dev/null' | e!
command! -nargs=0 StripWhitespace call functions#StripWhitespace()
command! -nargs=0 FollowSymlink call functions#FollowSymlink()
command! -nargs=* Stab call functions#Stab(<f-args>)
command! -bar -nargs=* Scratch call functions#ScratchEdit(<q-args>)
command! -nargs=0 Rename call functions#Rename()

" this is for stop profiling after starting vim with
" vi --cmd 'profile start vimrc.profile' --cmd 'profile func *' --cmd 'profile file *'
" I have a script in ~/bin which start vim like this
command! -nargs=0 StopProfiling call profile#stop()
" If I want to profile something after that vim started
command! -nargs=0 StartProfiling call profile#start()

" more consistent with other operator
nnoremap Y y$

" possible mnemonic? let say is for YELL
inoremap <C-y> <esc>gUiw`]a

" Practical Vim tip #34
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>ez :e ~/.zshrc<CR>
nnoremap <silent> <leader>et
      \ :call selecta#command("files -a -A ~/.cache/vtests", "", ":e")<cr>

" http://vimcasts.org/episodes/the-edit-command
" https://twitter.com/garybernhardt/status/40292706609532928
cnoremap %% <C-R>=expand('%:h').'/'<CR>
nmap <leader>e. :edit %%
nmap <leader>v. :view %%

nnoremap <C-n> :set invnumber<cr>

nnoremap <silent> <Leader>* :let @/ = '\<'.expand('<cword>').'\>' <Bar> set hlsearch<cr>

" Since the * is on the 8 symbol and is used to search for the word under the
" cursor, seems reasonable
nnoremap <silent> <Leader>8 :set hlsearch<cr>
" XXX: see if is necessary now that I don't start with nohlsearch
" cnoremap <silent> <expr> <cr>
"       \ getcmdtype() =~ '[/?]' ? '<cr>:nohlsearch<cr>' : '<cr>'

" Make selecting inside an HTML tag better
xnoremap <silent> it itVkoj
xnoremap <silent> at atV

" CTRL-U and CTRL-W in insert mode cannot be undone.  Use CTRL-G u to first
" break undo, so that we can undo those changes after inserting a line break.
" For more info, see: http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

nnoremap <silent> <Leader>s
      \ :call selecta#command("files -A", "", ":e")<cr>
nnoremap <silent> <Leader>g
      \ :call selecta#command("files -A", "-s ".expand('<cword>'), ":e")<cr>

" ##########
" Autocmd(s)
" ##########
augroup no_cursor_line_in_insert_mode
  autocmd!
  autocmd BufEnter,WinEnter,InsertLeave * set cursorline
  autocmd BufLeave,WinLeave,InsertEnter * set nocursorline
augroup END

augroup last_position_jump
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                     \|   execute 'normal! g`"zvzz'
                     \| endif
augroup END

" Every ftplugin in macvim runtime file override this
augroup remove_formatoptions_o
  autocmd!
  autocmd FileType * setlocal formatoptions-=o
augroup END

" for profiling
augroup profiling_vimrc
  autocmd!
  autocmd BufReadPost vim.profile setl ft=vim nolist
augroup END

augroup lcd_to_git_root_or_restore_last_set
  autocmd!
  autocmd BufLeave * let b:last_cwd = getcwd()
  autocmd BufEnter * if exists('b:last_cwd')
                  \|   execute 'lcd' b:last_cwd
                  \| else
                  \|   try
                  \|     execute 'lcd' '`=fugitive#repo().tree()`'
                  \|   catch
                  \|   endtry
                  \| endif
augroup END

" When switching solarized background color in vim change the solarized
" profile in iTerm as well.
augroup change_iterm_solarized_profile
  autocmd!
  autocmd VimEnter,ColorScheme * if !has('gui_running')
                              \|   if g:colors_name == "solarized"
                              \|     execute 'silent! !printf' printf('"\033]50;SetProfile=solarized_%s\x7"', &background)
                              \|   else
                              \|     execute 'silent! !printf' printf('"\033]50;SetProfile=%s\x7"', g:colors_name)
                              \|   endif
                              \| else
                              \|   autocmd! change_iterm_solarized_profile
augroup END

" XXX:
augroup temporary_prolog_settings
  autocmd!
  autocmd BufNewFile,BufRead *.pl setlocal filetype=prolog
  autocmd Filetype prolog setl et sts=8 ts=8 sw=8
  autocmd Filetype prolog let b:start = 'swipl %' | let b:dispatch = b:start
  autocmd Filetype prolog nnoremap <buffer> <CR> :w<Bar>:Start<cr>
augroup END

" Just so I don't lose them xD  ᕕ( ᐛ )ᕗ  ¯\_(ツ)_/¯
