
set number         "行番号を表示
set whichwrap=b,s,h,l,<,>,[,] "行頭行末の左右移動で行をまたぐ
set ignorecase     "検索で大文字と小文字を区別しない
set tabstop=3      "インデント幅
set autoindent     "改行時のインデントを継続
set shiftwidth=3   "自動インデントでずれる幅
set mouse=a        "マウスの入力を受け付ける
"コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
set history=100    "コマンドの履歴
set autoread       "他で書き換えられた場合、自動で読み直す
set ruler          "カーソルの位置情報を表示
set showcmd        "入力中のステータスを表示する

syntax on

inoremap <C-h> <LEFT>
inoremap <C-j> <DOWN>
inoremap <C-k> <UP>
inoremap <C-l> <RIGHT>
inoremap <C-d> <BS>
inoremap <C-c> <Esc>
inoremap <C-e> <Esc>

nnoremap s <Nop>
nnoremap sT :<C-u>NERDTree<CR>
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
nnoremap sq :<C-u>wq<CR>
