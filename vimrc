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
let g:Guifont="Monospace:h10"

" Compatibility
if has("unix")
  let s:uname = system("uname")
  let g:python_host_prog='/usr/bin/python'
  if s:uname == "Darwin\n"
    let g:python_host_prog='/usr/local/bin/python' " found via `which python`
  endif
endif

if has('nvim') || (v:version >= 800)
    " NVim's (and Vim8) terminal: esc to leave the terminal
    :tnoremap <Esc><Esc> <C-\><C-n>
endif
if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
else
    let s:editor_root=expand("~/.vim")
endif

" END NEOVIM SPECIFICS

set autoindent
set cindent

set formatoptions+=r


filetype plugin on

" To have tab to complete well in command mode
set wildmode=longest,list,full
set wildmenu

" Load legacy menubar, you can load the menu with :emenu
source $VIMRUNTIME/menu.vim

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


" ----------------------------------------------------------------------------
"   Plug
" ----------------------------------------------------------------------------

" Install vim-plug if we don't already have it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:editor_root . '/plugged')

" Coloscheme
"Plug 'captbaritone/molokai'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-fugitive'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'jremmen/vim-ripgrep'
Plug 'jlanzarotta/bufexplorer'
Plug 'vim-scripts/autoload_cscope.vim'
Plug 'godlygeek/tabular'
Plug 'Cofyc/vim-uncrustify'
Plug 'scrooloose/nerdtree'
Plug 'jszakmeister/vim-togglecursor'
Plug 'digitaltoad/vim-pug'
Plug 'wavded/vim-stylus'
Plug 'pboettch/vim-cmake-syntax'
Plug 'Valloric/MatchTagAlways'
Plug 'kergoth/vim-bitbake'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nanotech/jellybeans.vim'

" Rust stuff
Plug 'rust-lang/rust.vim'
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
" I commented the above ones because the intellisense one seems to work better

" intellisense for vim
" It requires node, to install it do:
" curl -sL install-node.now.sh/lts | bash
Plug 'neoclide/coc.nvim', {'branch': 'release'}


filetype plugin indent on                   " required!
call plug#end()


"colorscheme desert
let g:rehash256 = 1
colorscheme jellybeans



syntax on

set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" allow toggling between local and default mode
function! IndentToggle()
  if &expandtab
    " Standard mode
    set tabstop=8
    set shiftwidth=8
    set softtabstop=0
    set noexpandtab
    echo 'Indent to 8'
  else
    " Local settings
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set expandtab
    echo 'Indent to 4'
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

" Uncrustify
let g:uncrustify_cfg_file_path = "~/.uncrustify.cfg"  " path to uncrustify configuration file
autocmd FileType c noremap <buffer> <c-f> :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <c-f> :call RangeUncrustify('c')<CR>

" Mark 80 text width and switch with F8
set colorcolumn=+1
hi ColorColumn guibg=#2d2d2d ctermbg=246
let s:limit80=1
function! TextWidthToggle()
    if s:limit80 == 1
        echo "Disable limit 80"
	" Just set it big big big
	set textwidth=32000
        let s:limit80 = 0
    else
        echo "Enable limit 80"
	set textwidth=80
        let s:limit80 = 1
    endif
endfunction
inoremap <F8> <Esc>:call TextWidthToggle()<CR>
noremap <F8> :call TextWidthToggle()<CR>

" Ctrl-P root is current dir
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
"noremap <C-P> <Esc>:Ctrlp .<CR>

" On GVim, set font size to 10
if has("gui_gtk2")
	set guifont=Ubuntu\ Mono\ 11
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

" Sometimes the mouse is not enabled in terminal...
:set mouse=a
" Fully powered mouse support
if has("mouse_sgr")
	set ttymouse=sgr
else
	set ttymouse=xterm2
endif

"Vim airline theme
let g:airline_theme="bubblegum"

"Highlight as you type
set incsearch

"Coc configuration
" Taken from this page:
"
" https://ianding.io/2019/07/29/configure-coc-nvim-for-c-c++-development/
"
" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


