" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" from /usr/share/vim/vim82/vimrc_example.vim

if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup    " keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile " keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Add optional packages.
" The matchit plugin makes the % command work better, but it is not 
" backwards compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.

if has('syntax') && has('eval')
  packadd! matchit
endif


" Commented out some settings from my .vimrc here
" because now they are loaded from defaults.vim

"""
" General
set number      " dsplay line number
" set ruler " always show current position (in default)
" set showcmd " show first characters of incomplete commands (in default)
set encoding=utf-8
set cc=79 " color columns exceeding 79 characters
set autowrite " write files before switching buffers
" when saving session, restore the size of Vim window
set sessionoptions+=resize
" To prevent folds from opening when hopping over them with {} movements
set foldopen-=block
" enable mouse
set mouse=a

"""
" files, directories, buffer
" always show the status line
set laststatus=2
" format the status line
set statusline=%F%m%r%h\ %w\ [TYPE=%Y\ %{&ff}]\ CWD:%r%{getcwd()}%h\ \ \ 
            \Ln:%l(%L)\(%p%%)\ Cl:%c
" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>
" Put backups and swap files into predefined dirs for that purpose, 
" not all over the system. Make those dirs in your .vim folder first.
set backupdir=~/.vim/backup//
set directory=$HOME/.vim/swp//
set undodir=$HOME/.vim/undo//

"""
" COLOR
" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" sonokai colorscheme
" The configuration options should be placed before `colorscheme sonokai`.
if has('termguicolors')
  set termguicolors
endif

"let g:sonokai_style = 'atlantis'
"let g:sonokai_better_performance = 1
"colorscheme sonokai

" other color schemes
"colorscheme termschool
colorscheme tango-morning

"""
" syntax
syntax on " syntax highlighting

"""
" tabs and spaces
"set tabstop=4
"set expandtab
"set shiftwidth=4

au BufNewFile,BufRead *.py,*.vim,*.sh
    \ set tabstop=4
    \ softtabstop=4
    \ shiftwidth=4 " autoindentation
" Unless you want vim to actually break lines for you, better to column color
"    \ set textwidth=79
    \ expandtab " converts all tabs to spaces
    \ autoindent
    \ fileformat=unix

"au BufNewFile,BufRead *.js,*htm,*.html,*.css
"    \ set tabstop=2  "Note
"    \ softtabstop=2
"    \ shiftwidth=2
"Note, if starts to indent 4, just close file, reopen, indents 2 spaces

au BufNewFile,BufRead *.js,*htm,*.html,*.css set tabstop=2 softtabstop=2 shiftwidth=2

set tabstop=4
set expandtab
set shiftwidth=4

" When loosing html indent, use this to see where indent options were set
" :verbose setlocal ts? sts? sw? et?

set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅  " make spaces visible
set smarttab
set si "Smart indent

" Delete trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee 
                \:call CleanExtraSpaces()
endif

" mark extra whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


"""
" SEARCH
" set hlsearch    " highlight all search results
" do case insensitive search unless pattern has uppercase letters
set ignorecase smartcase
set incsearch   " show incremental search results as you type

"""
" MAPPINGS
" To avoid switching between keyboards to enter normal mode when in RU
" keyboard
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,
            \фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz,
            \юэЖъх;.':][  

" <leader> by default has value \
" Note, don't use nnoremap or nmap for mappings to work with RU keyboard.
" Use \\ to turn off search highlighting :nohls
map <leader>\ :nohlsearch<CR>
" Use \b to put braces around a word (with cursor on the first character)
map <leader>b i{<Esc>ea}<Esc>
" Use \o, also with count like 3\o 
" to make blank lines without leaving normal mode
map <leader>o o<Esc>
" For smoother scrolling, 6 lines, default 1/2 screen for CTRL-U, D.
" Use \e to add line break without leaving normal mode.
map <leader>e i<CR><Esc>
map <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
map <C-D> <C-E><C-E><C-E><C-E><C-E><C-E>

" Mappings for Spellcheck
" Use \s - Turn on spellcheck ENG + RU
map <leader>s :setlocal spell spelllang=en_us,ru<CR>
" Use \n - Turn off spellcheck (get rid of highlighting)
map <leader>n :set nospell<CR>

"Mapping to close html tags
imap ,/ </<C-X><C-O><C-X><Esc>F<i

" Mappings to comment out\in blocks of code.
" Select code you want to comment out in visual.
" Type F12 to comment out.
noremap <F12> :s/^/#<CR>:nohls<CR>
" Type Shifted F12 to comment in.
noremap <S-F12> :s/^#/<CR>:nohls<CR>

" To run python code from vim.
" Run with F9 from normal mode.
nmap <F9> :w<CR>:!python3 %<CR>
" Run with shifted F9 with clear terminal
nmap <S-F9> :w<CR>:!clear;python3 %<CR>
" Run with F5 using :term in split window
autocmd Filetype python nnoremap <buffer> <F5> :w<CR>:ter python3 "%"<CR>
" Shifted F5 in vertical split
autocmd Filetype python nnoremap <buffer> <S-F5> :w<CR>:vert ter python3 "%"<CR>


"""
" OTHER
" Return to last edit position when opening files.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") 
            \| exe "normal! g'\"" | endif
" Show match for brackets
set showmatch
set matchtime=7

"""
" PLUGINS
filetype plugin on

" FILETYPE
"filetype indent on




