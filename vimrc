" This script is a mix of different ones, so I cannot state I am the original
" author. For example, I took many protions from here:
" https://github.com/arusahni/dotfiles/blob/45c6655d46d1f672cc36f4e81c2a674484739ebc/vimrc


syntax enable

"
" Neovim specifics here:
"

" Neovim-qt Guifont command, to change the font
command! -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>")
" Set font on start
let g:Guifont="Monospace:h8"

" Compatibility
if has("unix")
  let s:uname = system("uname")
  let g:python_host_prog='/usr/bin/python'
  if s:uname == "Darwin\n"
    let g:python_host_prog='/usr/local/bin/python' " found via `which python`
  endif
endif

if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
    " NVim's terminal: esc to leave the terminal
    :tnoremap <Esc><Esc> <C-\><C-n>
else
    let s:editor_root=expand("~/.vim")
endif

" END NEOVIM SPECIFICS

set autoindent
set cindent

set formatoptions+=r


filetype plugin on

" ctrl+a select all
" map <C-a> ggVG
" Commented because of mswin remap is better

" To have tab to complete well in command mode
set wildmode=longest,list,full
set wildmenu

" Load legacy menubar, you can load the menu with :emenu
source $VIMRUNTIME/menu.vim

" map autocompletion
"inoremap <C-Space> <C-n>
"inoremap <NUL> <C-n>

" search not case-sensitive
set ignorecase
set smartcase

set ruler
set title
set number

" *****************************************************************************
"
" HERE MSWIN STARTS
"
" from http://vim.cybermirror.org/runtime/mswin.vim
"
" *****************************************************************************

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
behave mswin

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
vnoremap <BS> d

" Cross platform clipboard
set clipboard^=unnamed,unnamedplus

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP

cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
"noremap <C-Y> <C-R>
"inoremap <C-Y> <C-O><C-R>
"noremap <S-C-Z> <C-R>
"inoremap <C-S-Z> <C-O><C-R>

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>Ggvim
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG


" Setup Molokai color theme
let molokai_installed=1
let molokai_theme=s:editor_root . '/colors/molokai.vim'
if !filereadable(molokai_theme)
    echo "Installing Molokai.."
    echo ""
    silent execute "!rm -rf " . s:editor_root . "/molokai"
    silent execute "!git clone https://github.com/tomasr/molokai.git " . s:editor_root . "/molokai"
    silent execute "!mkdir -p " . s:editor_root . "/colors/"
    silent execute "!cp " . s:editor_root . "/molokai/colors/molokai.vim " . s:editor_root . "/colors/"
    silent execute
    let molokai_installed=0
endif

"colorscheme desert
let g:rehash256 = 1
colorscheme molokai



" Setting up Vundle - the vim plugin bundler
let vundle_installed=1
let vundle_readme=s:editor_root . '/bundle/vundle/README.md'
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    " silent execute "! mkdir -p ~/." . s:editor_path_name . "/bundle"
    silent call mkdir(s:editor_root . '/bundle', "p")
    silent execute "!git clone https://github.com/gmarik/vundle " . s:editor_root . "/bundle/vundle"
    let vundle_installed=0
endif
let &rtp = &rtp . ',' . s:editor_root . '/bundle/vundle/'
call vundle#rc(s:editor_root . '/bundle')

" let Vundle manage Vundle, required
"Plugin 'gmarik/Vundle.vim'


Plugin 'Tagbar'
Plugin 'ctrlp.vim'
Plugin 'rainbow_parentheses.vim'
Plugin 'Syntastic'
Plugin 'tpope/vim-fugitive'
"Plugin 'Tag-Signature-Balloons'
Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'rking/ag.vim'
Plugin 'bufexplorer.zip'
Plugin 'autoload_cscope.vim'
"Plugin 'Shougo/vimproc.vim' "vimproc requires compilation!
"Plugin 'kana/vim-operator-user'
"Plugin 'rhysd/vim-clang-format'
Plugin 'godlygeek/tabular'
Plugin 'Cofyc/vim-uncrustify'
Plugin 'The-NERD-tree'
Plugin 'jszakmeister/vim-togglecursor'
Plugin 'rust-lang/rust.vim'
Plugin 'digitaltoad/vim-pug'
Plugin 'wavded/vim-stylus'

if vundle_installed == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif
" Setting up Vundle - the vim plugin bundler end


call vundle#end()            " required
filetype plugin indent on    " required
syntax on

set smartindent
set tabstop=8
set shiftwidth=8
set noexpandtab
" allow toggling between local and default mode
function! IndentToggle()
  if &expandtab
    " Standard mode
    set tabstop=8
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
  else
    " Local settings
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set expandtab
  endif
endfunction
:nmap <F12> mz:execute IndentToggle()<CR>'z
" :imap <F12> :IndentToggle()<CR>

" Bufexplorer keystrokes
:imap <F3> <ESC>:BufExplorer<CR>
:map <F3> :BufExplorer<CR>

" NerdTree keystrokes
:imap <F4> <ESC>:NERDTreeToggle<CR>
:map <F4> :NERDTreeToggle<CR>
:imap <F5> <ESC>:NERDTreeFind<CR>
:map <F5> :NERDTreeFind<CR>

" TlistOpen replacement, Tagbar
:imap <F6> <ESC>:TagbarToggle<CR>
:map <F6> :TagbarToggle<CR>

" ctrl+backspace to delete whitespace
imap <c-backspace> <c-w>

" highlight searched text
set hlsearch

" wrap around when searching
:set wrapscan

" remove trailing whitespaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Buffer Explorer - sort by name by default
let g:bufExplorerSortBy='name'

" Markdown: disable folding
let g:vim_markdown_folding_disabled=1

autocmd FileType c noremap <buffer> <c-f> :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <c-f> :call RangeUncrustify('c')<CR>

" Mark 80 text witdth
set textwidth=80
set colorcolumn=+1
hi ColorColumn guibg=#2d2d2d ctermbg=246

" Ctrl-P root is current dir
let g:ctrlp_working_path_mode = 'ra'
noremap <C-P> <Esc>:Ctrlp .<CR>

" On GVim, set font size to 9
if has("gui_gtk2")
  set guifont=Monospace\ 9
endif

" Centralize swp files
let directory = s:editor_root . '/swap/'
if exists("*mkdir")
    if !isdirectory(directory)
        call mkdir(directory)
    endif
endif
if !isdirectory(directory)
    echo "Warning: Unable to create backup directory: " . directory
    echo "Try: mkdir -p " . directory
else
    exec "set directory=" . directory
endif

" jade has been renamed pug
autocmd BufNewFile,BufRead *.jade set syntax=pug
autocmd BufNewFile,BufRead *.pug set syntax=pug

" Stylus syntax
autocmd BufNewFile,BufRead *.styl set syntax=stylus
