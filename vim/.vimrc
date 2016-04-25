
set nocompatible

"syntax highlight
syntax on
highlight Comment ctermfg=gray

"keyboard and mouse
set backspace=start,eol,indent
set whichwrap=b,s,[,],<,>,~
set mouse=a

"file
set number
set ruler
set ambiwidth=double "文脈によって解釈が異なる全角文字の幅を、2に固定する
set tabstop=4        "インデント幅
set shiftwidth=4     "vimが自動で生成する（読み込み時など）tab幅をスペース4つ文にする
set expandtab        "tabを半角スペースで挿入する
set smartindent      "改行時などに、自動でインデントを設定してくれる
set autoindent       "改行時のインデントを継続
set autoread
set nowrap
set scrolloff=5      " スクロールする時に下が見えるようにする

"status line
set laststatus=2
highlight StatusLine term=bold cterm=bold ctermfg=black ctermbg=gray
set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

"searching
set ignorecase
set incsearch
set nohlsearch       "no highlight search
nnoremap / /\v
nnoremap ? ?\v

"command
set history=100
set showcmd
set wildmenu wildmode=list:full

"mapping
inoremap <C-e> <Esc>
inoremap jj <Esc>
inoremap <C-h> <LEFT>
inoremap <C-j> <DOWN>
inoremap <C-k> <UP>
inoremap <C-l> <RIGHT>
inoremap <C-d> <BS>
nnoremap <C-j> 2<DOWN>
nnoremap <C-k> 2<UP>
nnoremap <C-l> e
vnoremap <C-j> 2<DOWN>
vnoremap <C-k> 2<UP>
vnoremap <C-l> e
noremap  <S-h> ^
noremap  <S-j> }
noremap  <S-k> {
noremap  <S-l> $
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap tree :<C-u>NERDTree<CR>
nnoremap shell :<C-u>VimShell<CR><ESC>:<C-u>set nonumber<CR>
vnoremap comment :<C-u>TComment<CR>
nnoremap s <Nop>
nnoremap ss :<C-u>split<CR>
nnoremap sv :<C-u>vsplit<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sw <C-w>w
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap s= <C-w>=
nnoremap s> <C-w>>
nnoremap s< <C-w><
nnoremap s+ <C-w>+
nnoremap s- <C-w>-
nnoremap == gg=G''
noremap m %
inoremap <C-b> <ESC>:read ~/.vim/bf<CR>i
nnoremap <C-b> :read ~/.vim/bf<CR>
vnoremap <C-b> :w!~/.vim/bf<CR>

"git
set spelllang=en,cjk                       "スペルチェック
autocmd FileType gitcommit setlocal spell  "コミット時のスペルチェック
autocmd FileType gitcommit startinsert
runtime ftplugin/man.vim                   "マニュアル
nnoremap git :<C-u>Agit<CR>


""""""""""""""""""""""""""""""
" Vim-Plug
""""""""""""""""""""""""""""""
"
" ## Installation
" Download plug.vim and put it in the "autoload" directory.
"
"     curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" ## Usage
" Add a vim-plug section to your ~/.vimrc (or ~/.config/nvim/init.vim for Neovim):
"
" 1. Begin the section with plug#begin()
" 2. List the plugins with Plug commands
" 3. plug#end() to update &runtimepath and initialize plugin system
"
call plug#begin()
Plug 'tomtom/tcomment_vim'
Plug 'scrooloose/nerdtree'
Plug 'cohama/agit.vim', { 'commit': 'f663a12ff8868670687350d7b1bbe6d23673bc3b' }
Plug 'tpope/vim-fugitive'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/vimshell.vim'
Plug 'itchyny/lightline.vim'
call plug#end()


""""""""""""""""""""""""""""""
" 挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
""""""""""""""""""""""""""""""
