

set nocompatible
filetype plugin on
set pythonthreehome=~\\AppData\\Local\\Programs\\Python\\Python311
set pythonthreedll=~\AppData\Local\Programs\Python\Python311\python311.dll "current python installation dll
set encoding=utf-8
set softtabstop=2
set shiftwidth=4
set expandtab
set scrolloff=999  "to keep the cursor vertical centered
syntax on
filetype indent on
set autoindent
set foldenable  "Enable folding
set foldlevelstart=10 "open a max of 10 folder at the beginning
set foldnestmax=10
set foldmethod=indent
set foldcolumn=2
set nobackup
"colorscheme peachpuff "use gruvbox instead
set guifont=Cascadia_Code:h9
set cursorline
"highlight CursorLine guibg=orange ctermbg=lightgrey
set nu
set laststatus=2
"set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\ " -> use airline
set wildmenu
set directory=$HOME/.vim/swp// " save all the .swp files in this directory 
set undofile " mantain undo history between sessions
set undodir=$HOME/.vim/undodir " save all the undo history hidden files in this directory
set whichwrap=h,l "go to the next line if reach the end of a line 
"remap caps lock
"map <80> <ESC> doesn't work -> use autohotkey
map <C-K> :bprev!<CR>
"prossimo buffer
map <C-J> :bnext!<CR>
"precedente buffer
nnoremap n nzz 
"fissa la riga al centro della pagina quando si usa n
nnoremap N Nzz
"fissa la riga al centro della pagina quando si usa N
inoremap <BS> <left><DEL>
"backspace delete in insert mode
inoremap {<CR> {<CR>}<C-o>O
inoremap ( ()<left>
inoremap [ []<left>

"inoremap <M-]> <left><C-o>l<C-o>:call<space>search('[\])}]','cW')<return><C-o>a
"move cursor at the end of the next parentheses [dependency with whichwrap:]

"inoremap <M-[> <left><C-o>:call<space>GoToThePrevParentheses()<return>
"move cursor at before the previous parentheses [dependency with whichwrap]


function GoToThePrevParentheses()
  :s/\(^[\])}]\)/ \1/e
  return search('[\])}]','bcWp')
endfunction

call plug#begin('~/.vim/plugged')
  Plug '/mermaid.vim'
  Plug '/vim-airline'
  Plug '/nerdtree'
  Plug '/vim-fugitive'
  Plug '/YouCompleteMe'
  Plug '/vim-gitgutter'
  Plug '/vim-surround'
  Plug '/gruvbox'
  Plug '/rainbow_csv'
call plug#end()

"gruvbox
let g:gruvbox_contrast_light='soft'
let g:gruvbox_contrast_dark='soft'
set background=light "dark
autocmd vimenter * ++nested colorscheme gruvbox "this goes at the end of gruvbox options

"NERDTree
command NT NERDTree
"autocmd VimEnter * NERDTree "| wincmd p <- if want to start the cursor on file

"rainbow csv
let g:rbql_with_headers=1
nnoremap <expr> <C-Left> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoLeft<CR>' : '<C-Left>'
nnoremap <expr> <C-Right> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoRight<CR>' : '<C-Right>'
nnoremap <expr> <C-Up> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoUp<CR>' : '<C-Up>'
nnoremap <expr> <C-Down> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoDown<CR>' : '<C-Down>'
