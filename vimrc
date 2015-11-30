set nocompatible              " be iMproved, required

syntax enable

colorscheme desert

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

" map autocompletion
"inoremap <C-Space> <C-n>
"inoremap <NUL> <C-n>

" search not case-sensitive
set ignorecase
set smartcase

" move tabs
"function! ShiftTab(direction)
"     let tab_number = tabpagenr()
"     if a:direction == 0
"         if tab_number == 1
"             exe 'tabm' . tabpagenr('$')
"         else
"             exe 'tabm' . (tab_number - 2)
"         endif
"     else
"         if tab_number == tabpagenr('$')
"             exe 'tabm ' . 0
"         else
"         exe 'tabm ' . tab_number
"         endif
"     endif
"     return ''
"endfunction
"
"inoremap <silent> <C-S-PageUp>  <C-r>=ShiftTab(0)<CR>
"inoremap <silent> <C-S-PageDown>  <C-r>=ShiftTab(1)<CR>
"noremap <silent> <C-S-PageUp>  :call ShiftTab(0)<CR>
"noremap <silent> <C-S-PageDown> :call ShiftTab(1)<CR>

" switch tabs like firefox
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>


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
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG


" *****************************************************************************
" VUNDLE STUFF
" *****************************************************************************

"set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'


Plugin 'The-NERD-tree'

"Plugin 'Valloric/YouCompleteMe'

Plugin 'Tagbar'
Plugin 'ctrlp.vim'
Plugin 'rainbow_parentheses.vim'
Plugin 'Syntastic'
Plugin 'fugitive.vim'
Plugin 'Tag-Signature-Balloons'
Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'rking/ag.vim'
Plugin 'bufexplorer.zip'
Plugin 'autoload_cscope.vim'
Plugin 'Shougo/vimproc.vim' "vimproc requires compilation!
Plugin 'kana/vim-operator-user'
Plugin 'rhysd/vim-clang-format'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'Cofyc/vim-uncrustify'

call vundle#end()            " required
filetype plugin indent on    " required
syntax on


" *****************************************************
" This autocmd highlights the active word
"autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

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
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
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


if has("gui_running")
  if has("gui_gtk2")
    set guifont=Monospace\ 8
  endif
else
  set mouse=a
  colorscheme darkblue
  " allow selections in tty
  set ttymouse=xterm2
  set ttyfast
  " map autocompletion on remote xterm
  "inoremap <NUL> <C-n>

endif


"===============================================================
" Clang completion
"
" Everything commented, for now I won't enable it
"
""let g:clang_complete_copen = 1
""let g:clang_use_library = 1 deprecated
""let g:clang_library_path = '/opt/llvm-3.4/lib'
"let g:clang_library_path = '/opt/llvm-3.4.1/lib'
"let g:clang_close_preview = 1
""let g:clang_snippets = 1
""let g:clang_snippets_engine = 'snipmate'
"let g:clang_periodic_quickfix = 0
"map <buffer> <silent> <F5> :call g:ClangUpdateQuickFix()<CR>
"" This shall disappear once cindex.py can check if the CompilationDB feature
"" is available :
"let g:clang_auto_user_options = 'path, compile_commands.json'
""let g:clang_user_options = '-Wall'
"let g:clang_complete_copen = 1
"let g:clang_complete_macros = 1
"let g:clang_complete_patterns = 1
"" insert text automatically when there is only one posiibility
"set completeopt=menu,longest
"
"function! ClangPeriodicToggle()
"   if g:clang_periodic_quickfix == 0
"      let g:clang_periodic_quickfix = 1
"   else
"      let g:clang_periodic_quickfix = 0
"   endif
"   echo "Clang Periodic Quickfix " g:clang_periodic_quickfix
"endfunction
":imap <F8> <ESC>:call ClangPeriodicToggle()<CR>
":map <F8> :call ClangPeriodicToggle()<CR>


" Clang format
" you need to install clang-format binary to have this working
map <F9>  :ClangFormat<CR>
imap <F9> <ESC>:ClangFormat<CR>i
let g:clang_format#command="clang-format-3.5"
" A style that should be similar to linux kernel one
"let g:clang_format#style_options = {
"            \ "BasedOnStyle" : "LLVM",
"            \ "IndentWidth" : "8",
"            \ "UseTab" : "Always",
"            \ "BreakBeforeBraces" : "Linux",
"            \ "AllowShortIfStatementsOnASingleLine" : "false",
"            \ "IndentCaseLabels" : "false"
"\}

" ctrl+backspace to delete whitespace
imap <c-backspace> <c-w>

" highlight searched text
set hlsearch

" wrap around when searching
:set wrapscan

" YCM settings
let g:ycm_global_ycm_extra_conf = "~/.vim/ycm.py"

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



