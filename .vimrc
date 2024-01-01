set nocompatible
syntax on
filetype plugin indent on
set pythonthreehome=~\\AppData\\Local\\Programs\\Python\\Python311
set pythonthreedll=~\AppData\Local\Programs\Python\Python311\python311.dll "current python installation dll
set encoding=utf-8
set softtabstop=2
set shiftwidth=4
set expandtab "tabs are spaces
set scrolloff=999  "to keep the cursor vertical centered
set autoindent
set foldenable  "Enable folding
set foldlevelstart=10 "open a max of 10 folder at the beginning
set foldnestmax=10
set foldmethod=indent
set foldcolumn=2
set nobackup
"colorscheme peachpuff "use gruvbox instead
set guifont=Cascadia_Code:h10
set cursorline
"highlight CursorLine guibg=orange ctermbg=lightgrey
set nu
set laststatus=2
"set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\ " -> use airline
set wildmenu
set wildmode=list:longest,full
set hidden "buffer and args are traversed without saving first
set path=./** "to use find on pwd and subdirectories
set directory=$HOME/.vim/swp// " save all the .swp files in this directory 
set undofile " mantain undo history between sessions
set undodir=$HOME/.vim/undodir " save all the undo history hidden files in this directory
set whichwrap=h,l "go to the next line if reach the end of a line 
"remap caps lock
nnoremap n nzz 
"fissa la riga al centro della pagina quando si usa n
nnoremap N Nzz
"fissa la riga al centro della pagina quando si usa N
inoremap <BS> <left><DEL>
"backspace delete in insert mode
imap {<CR> {<CR>}<C-o>O
inoremap ( ()<left>
inoremap [ []<left>
if has("gui_running")
    "suppress error bell sound
    autocmd GUIEnter * set vb t_vb=
endif

"inoremap <M-]> <left><C-o>l<C-o>:call<space>search('[\])}]','cW')<return><C-o>a
"move cursor at the end of the next parentheses [dependency with whichwrap:]

"inoremap <M-[> <left><C-o>:call<space>GoToThePrevParentheses()<return>
"move cursor at before the previous parentheses [dependency with whichwrap]


function GoToThePrevParentheses()
  :s/\(^[\])}]\)/ \1/e
  return search('[\])}]','bcWp')
endfunction

function SetAutoSave()
    au TextChanged,TextChangedI <buffer> silent write
endfunction

"preview of asciidoc on chrome
au BufNewFile,BufRead *.adoc
        \ command! Preview silent execute "!chrome ".shellescape(expand('%:p')) 
"call SetAutoSave() 

"csv autodetect
au BufNewFile,BufRead *.csv,*.csv*txt
        \ if getline(1) =~ '^[^|]*|.*$' |
	\   setf csv_pipe |
        \ elseif getline(1) =~ '^[^;]*;.*$' |
        \   setf csv_semicolon |
        \ elseif getline(1) =~ '^[^\t]*\t.*$' |
        \   setf tsv |
        \ else | 
	\   setf csv |
	\ endif |

"plugins
call plug#begin('~/.vim/plugged')
  Plug 'https://github.com/mracos/mermaid.vim.git' "'/mermaid.vim'
 "Plug 'https://github.com/craigmac/vim-mermaid.git' "'/vim-mermaid'
  Plug 'https://github.com/vim-airline/vim-airline.git' "'/vim-airline'
  Plug 'https://github.com/preservim/nerdtree.git' "'/nerdtree'
  Plug 'https://github.com/tpope/vim-fugitive.git' "'/vim-fugitive'
  if has("gui_running")
      Plug 'https://github.com/ycm-core/YouCompleteMe.git', { 'for': 'javascript' } "'/YouCompleteMe'
  endif
  Plug 'https://github.com/airblade/vim-gitgutter.git' "'/vim-gitgutter'
  Plug 'https://github.com/tpope/vim-surround.git' "'/vim-surround'
  Plug 'https://github.com/morhetz/gruvbox.git' "'/gruvbox'
  Plug 'https://github.com/mechatroner/rainbow_csv.git' "'/rainbow_csv'
  "Plug 'https://github.com/vim-syntastic/syntastic.git' "'/syntastic'
  Plug 'https://github.com/tpope/vim-commentary.git' "'/vim-commentary'
  Plug '/argtextobj'
  Plug 'https://github.com/kana/vim-textobj-entire.git' "/vim-textobj-entire'
  Plug 'https://github.com/machakann/vim-highlightedyank.git' "'/vim-highlightedyank'
  Plug 'https://github.com/kana/vim-textobj-user.git' "'/vim-textobj-user'
  Plug 'https://github.com/michaeljsmith/vim-indent-object.git' "'/vim-indent-object'
  Plug 'https://github.com/unblevable/quick-scope.git' "'/quick-scope'
  Plug 'https://github.com/tpope/vim-unimpaired.git' "'/vim-unimpaired.git'
  Plug 'https://github.com/tpope/vim-repeat.git' "'/vim-repeat.git'
  Plug 'https://github.com/rhysd/vim-healthcheck.git' "'/vim-healthcheck'
call plug#end()

"quickscope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#ff0000' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#0000ff' gui=underline ctermfg=81 cterm=underline
augroup END

"gruvbox
let g:gruvbox_contrast_light='soft'
let g:gruvbox_contrast_dark='soft'
if has("gui_running")
    set background=light
else
    set background=dark
endif
autocmd vimenter * ++nested colorscheme gruvbox "this goes at the end of gruvbox options
if &ft =~ 'mermaid' "current mermaid plugin is incompatible with gruvbox
   autocmd colorscheme * syntax on
endif

"NERDTree
command NT NERDTree
nnoremap <C-N> :NERDTree<CR>
"autocmd VimEnter * NERDTree "| wincmd p <- if want to start the cursor on file

"rainbow csv
autocmd vimenter *.csv colorscheme sorbet
autocmd vimenter *.csv set nowrap
let g:rbql_with_headers=1
let g:rbql_backend_language='javascript' "python
let g:disable_rainbow_hover=1
"let g:rcsv_colorpairs = [['blue','blue'], ['red', 'red']]
nnoremap <expr> <C-Left> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoLeft<CR>' : '<C-Left>'
nnoremap <expr> <C-Right> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoRight<CR>' : '<C-Right>'
nnoremap <expr> <C-Up> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoUp<CR>' : '<C-Up>'
nnoremap <expr> <C-Down> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoDown<CR>' : '<C-Down>'


"git-gutter
let g:gitgutter_set_sign_backgrounds=0
highlight GitGutterAdd guifg=#009900 ctermfg=Green
highlight GitGutterChange guifg=#bbbb00 ctermfg=Yellow
highlight GitGutterDelete guifg=#ff2222 ctermfg=Red
function! GitStatus()
      let [a,m,r] = GitGutterGetHunkSummary()
        return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}

"git-fugitive
command W Gwrite
command C Git commit

"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

