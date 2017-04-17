" vim-sublime - A minimal Sublime Text - like vim experience bundle
"               http://github.com/grigio/vim-sublime
" Best view with a 256 color terminal and Powerline fonts
" Updated by Dorian Neto (https://github.com/dorianneto)"

set nocompatible
filetype off

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'kien/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'flazz/vim-colorschemes'
Plug 'masmu/vim-move'
Plug 'kchmck/vim-coffee-script'
Plug 'jiangmiao/auto-pairs'
Plug 'ervandew/supertab'
Plug 'mustache/vim-mustache-handlebars'
call plug#end()

filetype plugin indent on

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Use :help 'option' to see the documentation for the given option.
set autoindent
set backspace=indent,eol,start
set complete-=i
set showmatch
set showmode
set smarttab
set cursorline

set nrformats-=octal
set shiftround

set ttimeout
set ttimeoutlen=50

set incsearch

set laststatus=2
set ruler
set showcmd
set wildmenu

set autoread

set encoding=utf-8
set tabstop=2 shiftwidth=2 expandtab
set listchars=tab:▒░,trail:▓,eol:↲
set list

set number
set hlsearch
set ignorecase
set smartcase

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Do not history when leavy buffer
set hidden

set nobackup
set nowritebackup
set noswapfile
set fileformats=unix,dos,mac
set completeopt=longest,menuone,preview
set timeoutlen=100 ttimeoutlen=0

" Include easy mode keybindings
source $VIMRUNTIME/evim.vim
set insertmode

if filereadable(expand("~/.vimrc.keycodes"))
  source ~/.vimrc.keycodes
endif

" -----------------------------------------------------------------
" Plugins config
" -----------------------------------------------------------------

" nerdtree
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
" close vim if nerdtree is the last remaining window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" vim-colorschemes
if filereadable(expand("~/.vim/plugged/vim-colorschemes/colors/Tomorrow-Night.vim"))
    colorscheme Tomorrow-Night
endif

" ctrlp
let g:ctrlp_cmd = 'CtrlPMixed'          " search anything (in files, buffers and MRU files at the same time.)
let g:ctrlp_working_path_mode = 'ra'    " search for nearest ancestor like .git, .hg, and the directory of the current file
let g:ctrlp_match_window_bottom = 0     " show the match window at the top of the screen
let g:ctrlp_by_filename = 1
let g:ctrlp_max_height = 10             " maxiumum height of match window
let g:ctrlp_switch_buffer = 'et'        " jump to a file if it's open already
let g:ctrlp_use_caching = 1             " enable caching
let g:ctrlp_clear_cache_on_exit=0       " speed up by not removing clearing cache evertime
let g:ctrlp_mruf_max = 250              " number of recently opened files
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|build)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
\ }
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

let g:ctrlp_buftag_types = {
\ 'go'         : '--language-force=go --golang-types=ftv',
\ 'coffee'     : '--language-force=coffee --coffee-types=cmfvf',
\ 'markdown'   : '--language-force=markdown --markdown-types=hik',
\ 'objc'       : '--language-force=objc --objc-types=mpci',
\ 'rc'         : '--language-force=rust --rust-types=fTm'
\ }

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='badwolf'

" vim-move
let g:move_map_keys = 1
let g:move_auto_indent = 0

" markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

" supertab
let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0
let g:SuperTabLongestHighlight = 1
" auto close the popup
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" ----------------------------------------------------------------
" Commands
" ----------------------------------------------------------------

if !exists(":OrigamiVerticalSplit")
    :command OrigamiVerticalSplit               :vs
endif
if !exists(":OrigamiHorizontalSplit")
    :command OrigamiHorizontalSplit             :sp
endif
if !exists(":OrigamiCloseWindow")
    :command OrigamiCloseWindow                 :q
endif

if !exists(":CycleWindow")
    :command CycleWindow                        :wincmd p
endif
if !exists(":CycleTab")
    :command CycleTab                           :bnext
endif
if !exists(":ToggleComment")
    :command ToggleComment                      :Commentary
endif

" ----------------------------------------------------------------
" Cursor definitions
" ----------------------------------------------------------------

" Stops the cursor from jumping one position back when leaving insert mode
" http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
let CursorColumnI = 0
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" Disables readonly mode for files. You can save them with (Alt-S)
autocmd BufReadPost * set noreadonly

" Faster jumps
inoremap <A-Right>                              <C-O>w
inoremap <A-Left>                               <C-O>b
inoremap <C-Right>                              <C-O>W
inoremap <C-Left>                               <C-O>B

" Does nothing in sublime
snoremap <C-A-Right>                            <NOP>
snoremap <C-A-Left>                             <NOP>

" Jumping selection 
snoremap <S-A-Right>                            <C-S-A-Right>
snoremap <S-A-Left>                             <C-S-A-Left>

" Delete a line
inoremap <S-Del>                                <C-O>dd
snoremap <S-Del>                                :delete<CR>

" ----------------------------------------------------------------
" Shortcuts definitions
" ----------------------------------------------------------------

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Move lines horizontial
vnoremap <C-S-Up>                               :call MoveBlockOneLineUp()<CR>
vnoremap <C-S-Down>                             :call MoveBlockOneLineDown()<CR>
inoremap <C-S-Up>                               <C-O>:call MoveLineUp(1)<CR>
inoremap <C-S-Down>                             <C-O>:call MoveLineDown(1)<CR>

" Find, (n) for next, (N) for previous.
nnoremap <C-f>                                  /
inoremap <C-f>                                  <Esc>/
vnoremap <C-f>                                  <Esc>/

" Replace
inoremap <C-h>                                  <Esc>:%s/
nnoremap <C-h>                                  :%s/
vnoremap <C-h>                                  <Esc>:%s/

" Comment, Uncomment
" http://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
inoremap <C-_>                                  <C-O>:Commentary<CR>
vnoremap <C-_>                                  :Commentary<CR>

" Cut, Paste, Copy
snoremap <C-x>                                  <C-O>"ad
snoremap <C-c>                                  <C-O>"aygv
snoremap <C-v>                                  <C-O>"aP
inoremap <C-v>                                  <C-O>"aP

" Indend / Deindent after selecting the text with (⇧-v)
vnoremap <Tab>                                  >gv
vnoremap <S-Tab>                                <gv

" Undo / Redo in select mode
" snoremap <C-Z>                                  <Esc><C-O>ugv
" snoremap <C-Y>                                  <Esc><C-O><C-R>gv
vnoremap <C-Z>                                  <Esc><C-O>ugv
" vnoremap <C-Y>                                  <Esc><C-O><C-R>gv

" Open
nnoremap <C-o>                                  :NERDTreeToggle<CR>
inoremap <C-o>                                  <C-O>:NERDTreeToggle<CR>
snoremap <C-o>                                  <Esc><C-O>:NERDTreeToggle<CR>

" Save
nnoremap <C-s>                                  :update<CR>
inoremap <C-s>                                  <C-O>:update<CR>
snoremap <C-s>                                  <Esc><C-O>:update<CR>
nnoremap <A-s>                                  :w !sudo tee > /dev/null %<CR>
inoremap <A-s>                                  <C-O>:w !sudo tee > /dev/null %<CR>
snoremap <A-s>                                  <Esc><C-O>:w !sudo tee > /dev/null %<CR>

" Close
nnoremap <C-q>                                  :q<CR>
inoremap <C-q>                                  <C-O>:q<CR>
snoremap <C-q>                                  <Esc><C-O>:q<CR>
nnoremap <A-q>                                  :q!<CR>
inoremap <A-q>                                  <C-O>:q!<CR>
snoremap <A-q>                                  <Esc><C-O>:q!<CR>

" Tabs
nnoremap <C-PageUp>                             :bprevious<CR>
inoremap <C-PageUp>                             <C-O>:bprevious<CR>
vnoremap <C-PageUp>                             <Esc><C-O>:bprevious<CR>
nnoremap <C-PageDown>                           :bnext<CR>
inoremap <C-PageDown>                           <C-O>:bnext<CR>
vnoremap <C-PageDown>                           <Esc><C-O>:bnext<CR>
nnoremap <C-w>                                  :bd<CR>
inoremap <C-w>                                  <C-O>:bd<CR>
vnoremap <C-w>                                  <Esc><C-O>:bd<CR>
nnoremap <A-w>                                  :bd!<CR>
inoremap <A-w>                                  <C-O>:bd!<CR>
snoremap <A-w>                                  <Esc><C-O>:bd!<CR>


" Open files
inoremap <C-p>                                  <C-O>:CtrlPMixed<CR>

" Open symbol
inoremap <C-r>                                  <C-O>:CtrlPBufTag<CR>

" ----------------------------------------------------------------
" Local config
" ----------------------------------------------------------------

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
