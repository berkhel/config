set nocompatible
syntax on
filetype plugin indent on
set shell=powershell shellcmdflag=-c "set default shell
"set guioptions+=! 
set termwintype=conpty "allow on windows to open terminal inside vim
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
imap { {}<left>
imap {<CR> {<CR>}<C-o>O
inoremap ( ()<left>
inoremap [ []<left>
inoremap [<CR> [<CR>]<C-o>O

"suppress error bell sound
if has("gui_running")
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

" AutoSave
let g:AUTO_SAVE_FLAG = 0
function ToggleAutoSave()
    augroup au_save
        if g:AUTO_SAVE_FLAG == 0 
            autocmd TextChanged,TextChangedI <buffer> silent write
            let g:AUTO_SAVE_FLAG = 1
        else
            autocmd! TextChanged,TextChangedI <buffer>
            let g:AUTO_SAVE_FLAG = 0
        endif
    augroup END
endfunction
command! AutoSaveToggle call ToggleAutoSave()

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
let g:ENABLE_SYNTASTIC = 0
let g:ENABLE_YOUCOMPLETEME = 0
let g:ENABLE_COC = 1
call plug#begin('~/.vim/plugged')
Plug 'https://github.com/mracos/mermaid.vim.git' "'/mermaid.vim'
"Plug 'https://github.com/craigmac/vim-mermaid.git' "'/vim-mermaid'
Plug 'https://github.com/vim-airline/vim-airline.git' "'/vim-airline'
Plug 'https://github.com/preservim/nerdtree.git' "'/nerdtree'
Plug 'https://github.com/tpope/vim-fugitive.git' "'/vim-fugitive'
if has("gui_running") && g:ENABLE_YOUCOMPLETEME
    Plug 'https://github.com/ycm-core/YouCompleteMe.git', { 'for': 'javascript' } "'/YouCompleteMe'
endif
Plug 'https://github.com/airblade/vim-gitgutter.git' "'/vim-gitgutter'
Plug 'https://github.com/tpope/vim-surround.git' "'/vim-surround'
Plug 'https://github.com/morhetz/gruvbox.git' "'/gruvbox'
Plug 'https://github.com/mechatroner/rainbow_csv.git' "'/rainbow_csv'
if g:ENABLE_SYNTASTIC
    Plug 'https://github.com/vim-syntastic/syntastic.git' "'/syntastic'
endif
Plug 'https://github.com/tpope/vim-commentary.git' "'/vim-commentary'
Plug '/argtextobj'
Plug 'https://github.com/kana/vim-textobj-entire.git' "/vim-textobj-entire'
Plug 'https://github.com/machakann/vim-highlightedyank.git' "'/vim-highlightedyank'
Plug 'https://github.com/kana/vim-textobj-user.git' "'/vim-textobj-user'
Plug 'https://github.com/michaeljsmith/vim-indent-object.git' "'/vim-indent-object'
Plug 'https://github.com/unblevable/quick-scope.git' "'/quick-scope'
Plug 'https://github.com/tpope/vim-unimpaired.git' "'/vim-unimpaired'
Plug 'https://github.com/tpope/vim-repeat.git' "'/vim-repeat'
Plug 'https://github.com/rhysd/vim-healthcheck.git' "'/vim-healthcheck'
if has("gui_running") && g:ENABLE_COC
    Plug 'https://github.com/neoclide/coc.nvim.git', { 'for' : 'javascript' } "'/coc.nvim'
endif
Plug 'https://github.com/Eliot00/git-lens.vim.git' "'/git-lens.vim'
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
"open terminal with gruvbox colors
let g:terminals_open_array = []
function OpenTerminalGruvbox()
    if g:colors_name ==# 'gruvbox'
        if &bg ==# 'light'
            let first_word_color = "#282828"
            hi Terminal guibg=#EDE0B9 
            hi Terminal guifg=brown
        else
            let first_word_color = "#fe8019"
            hi Terminal guibg=#32302F 
            hi Terminal guifg=#40e0d0
        endif
        "#282828 black
        "#CC241D red
        "#98971A gold
        "#D79921 orange
        "#458588 cyan
        "#B16286 dark pink
        "#689D6A dark green
        "#D65D0E dark orange
        "#fb4934 bright red
        "#b8bb26 lime
        "#fabd2f bright orange
        "#83a598 dark cyan
        "#d3869b pink
        "#8ec07c green
        "#fe8019 vivid orange
        "#FBF1C7 cream
        for buf_num in g:terminals_open_array
            call term_setansicolors(buf_num, [
                        \"#282828", 
                        \"#CC241D", 
                        \"#98971A", 
                        \"#D79921", 
                        \"#b8bb26", 
                        \"#B16286", 
                        \"#689D6A", 
                        \"#D65D0E", 
                        \"#458588", 
                        \"#fb4934", 
                        \"#fabd2f", 
                        \first_word_color, 
                        \"#d3869b", 
                        \"#8ec07c", 
                        \"#fe8019", 
                        \"#FBF1C7"
                        \])
        endfor
    endif
endfunction
autocmd TerminalOpen * call add(g:terminals_open_array, buffer_number())  | call OpenTerminalGruvbox() 
autocmd ColorScheme * call OpenTerminalGruvbox()
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"set termguicolors

"NERDTree
command NT NERDTree
nnoremap <C-N> :NERDTree<CR>
"autocmd VimEnter * NERDTree "| wincmd p <- if want to start the cursor on file

"rainbow csv
autocmd vimenter *.csv colorscheme sorbet
autocmd vimenter *.csv set nowrap
if &filetype =~ 'csv'
    let g:rbql_with_headers=1
    let g:rbql_backend_language='javascript' "python
    let g:disable_rainbow_hover=1
    "let g:rcsv_colorpairs = [['blue','blue'], ['red', 'red']]
    nnoremap <expr> <C-Left> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoLeft<CR>' : '<C-Left>'
    nnoremap <expr> <C-Right> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoRight<CR>' : '<C-Right>'
    nnoremap <expr> <C-Up> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoUp<CR>' : '<C-Up>'
    nnoremap <expr> <C-Down> get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoDown<CR>' : '<C-Down>'
endif


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
if g:ENABLE_SYNTASTIC
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
endif

"json
let g:vim_json_warnings = 0

"coc.nvim
if has("gui_running") && g:ENABLE_COC && &filetype ==# 'javascript'

    " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    " delays and poor user experience
    set updatetime=300

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved
    set signcolumn=yes

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
        else
            call feedkeys('K', 'in')
        endif
    endfunction

    " Applying code actions to the selected code block
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying code actions at the cursor position
    nmap <leader>ac  <Plug>(coc-codeaction-cursor)
    " Remap keys for apply code actions affect whole buffer
    nmap <leader>as  <Plug>(coc-codeaction-source)
    " Apply the most preferred quickfix action to fix diagnostic on the current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Highlight the symbol and its references when holding the cursor
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap keys for applying refactor code actions
    nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
    xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
    nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
    " Symbol renaming
    nmap <leader>rn <Plug>(coc-rename)

    " Run the Code Lens action on the current line
    nmap <leader>cl  <Plug>(coc-codelens-action)

    " Remap <C-f> and <C-b> to scroll float windows/popups
    if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif

endif


"git-lens
command! GitLensToggle call ToggleGitLens()

