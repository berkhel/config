set nocompatible
syntax on
filetype plugin indent on
"set shell=powershell shellcmdflag=-c "set default shell to powershell
if has("gui_running")
    set guioptions+=! "use terminal inside Vim for :!<command>
    set termwintype=conpty "allow on windows to open terminal inside vim
endif
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

inoremap <silent> [ []<left>
inoremap [<CR> [<CR>]<C-o>O

"custom commands
"IntelliJIdea
command! Idea silent execute "!start /b idea64 ".shellescape(expand('%:p'))
"VSCode
command! Vscode silent execute "!start /b Code ".shellescape(expand('%:p'))

"suppress error bell sound
if has("gui_running")
    autocmd GUIEnter * set vb t_vb=
endif

function GoToThePrevParentheses()
    :s/\(^[\])}]\)/ \1/e
    return search('[\])}]','bcWp')
endfunction

"useful for other function
function PrintAfterCursor(text)
    exec "norm! a".a:text."\<right>"
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

"Visual mode selection text (Visual Block not supported yet)
function VisualModeSelectionText()
    let old = getreginfo('@')
    exec "norm! `<v`>y"
    let txt = getreg('@')    
    call setreg('@', old)
    return txt
endfunction

"Search on Google
function Google(keywords = substitute(VisualModeSelectionText(),'\n\|\r',' ','g')) range
        silent execute "!start chrome --extra-search-query-params ".shellescape("https://www.google.it/search?q='".a:keywords."'")
endfunction
command! -nargs=? -range Google call Google(<f-args>)

"preview of asciidoc on chrome
"and quick cite
let g:bibfilename = 'bib.adoc'
let g:diagram_renderer = '' " diagram | kroki
let g:asciidoctor_js_live_preview = 1

function BibCite(ref_id)
    call PrintAfterCursor("[<<".g:bibfilename."#".a:ref_id.",".a:ref_id.">>]")
endfunction

function BuildAsciidoc(it_contains_diagrams)
    if a:it_contains_diagrams
        silent execute "!start /b asciidoctor -r asciidoctor-".g:diagram_renderer." ".shellescape(expand('%:p'))
    else
        silent execute "!start /b asciidoctor ".shellescape(expand('%:p'))
    endif
    " silent call system("asciidoctor --safe-mode=server -r ".g:diagram_renderer." ".shellescape(expand('%:p')))
endfunction

function PreviewAsciidoc()
    let input_adoc = shellescape(expand('%:p'))
    let output_html = shellescape(expand('%:p:r').".html")
    if g:asciidoctor_js_live_preview
        silent execute "!start chrome ".input_adoc
    else
        call BuildAsciidoc(g:diagram_renderer !=# '')
        silent execute "!start chrome ".output_html
    endif
endfunction

au BufNewFile,BufRead *.adoc
            \ command! Preview call PreviewAsciidoc()
au BufNewFile,BufRead *.adoc
            \ command! -nargs=1 Cite call BibCite(<f-args>)
au BufNewFile,BufRead *.adoc
            \ imap <C-B> <C-O>:Cite<Space>
au BufNewFile,BufRead *.adoc
            \ command! Bib exec 'find bib.adoc'
au BufNewFile,BufRead *.adoc
            \ command! LivePreviewToggle let g:asciidoctor_js_live_preview=!g:asciidoctor_js_live_preview
au BufNewFile,BufRead *.adoc
            \ command! Diagram let g:diagram_renderer='diagram' | let g:asciidoctor_js_live_preview=0
au BufNewFile,BufRead *.adoc
            \ command! Kroki let g:diagram_renderer='kroki' | let g:asciidoctor_js_live_preview=0
au BufWritePost *.adoc
           \ if !g:asciidoctor_js_live_preview |
           \   call BuildAsciidoc(g:diagram_renderer !=# '') |
           \ endif
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
let g:COC_FILETYPES = 'javascript,c,cpp,asciidoc'
let g:ENABLE_ALE = 0
let g:ENABLE_COPILOT = 1
let g:ENABLE_CHATGPT = 0
call plug#begin('~/.vim/plugged')
Plug 'https://github.com/mracos/mermaid.vim.git'
"Plug 'https://github.com/craigmac/vim-mermaid.git' "'/vim-mermaid'
if has("gui_running")
    Plug 'https://github.com/vim-airline/vim-airline.git'
endif
Plug 'https://github.com/preservim/nerdtree.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
if has("gui_running") && g:ENABLE_YOUCOMPLETEME
    Plug 'https://github.com/ycm-core/YouCompleteMe.git', { 'for': 'javascript' } "'/YouCompleteMe'
endif
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'https://github.com/morhetz/gruvbox.git'
Plug 'https://github.com/mechatroner/rainbow_csv.git'
if g:ENABLE_SYNTASTIC
    Plug 'https://github.com/vim-syntastic/syntastic.git'
endif
Plug 'https://github.com/tpope/vim-commentary.git'
Plug '/argtextobj'
Plug 'https://github.com/kana/vim-textobj-entire.git'
Plug 'https://github.com/machakann/vim-highlightedyank.git'
Plug 'https://github.com/kana/vim-textobj-user.git'
Plug 'https://github.com/michaeljsmith/vim-indent-object.git' 
Plug 'https://github.com/unblevable/quick-scope.git' 
Plug 'https://github.com/tpope/vim-unimpaired.git' 
Plug 'https://github.com/tpope/vim-repeat.git' 
Plug 'https://github.com/rhysd/vim-healthcheck.git' 
if g:ENABLE_COC
    Plug 'https://github.com/neoclide/coc.nvim.git', { 'for' : g:COC_FILETYPES.''  } "'/coc.nvim'
endif
Plug 'https://github.com/Eliot00/git-lens.vim.git' 
Plug 'https://github.com/junegunn/fzf.git' , { 'do': { -> fzf#install() } } " 1)
Plug 'https://github.com/junegunn/fzf.vim.git' "2) you need both
"Plug 'https://github.com/vim-utils/vim-man.git' "'/vim-man'
"Plug 'https://github.com/yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
if g:ENABLE_ALE
    Plug 'https://github.com/dense-analysis/ale.git' 
endif
if g:ENABLE_COPILOT
    Plug 'https://github.com/github/copilot.vim.git', { 'on' : 'Copilot' }
endif
if g:ENABLE_CHATGPT
    Plug 'https://github.com/CoderCookE/vim-chatgpt.git' "'/vim-chatgpt'
endif
"Plug 'https://github.com/img-paste-devs/img-paste.vim.git' "'/img-paste.vim'
"this is good but not compliant with is security of the company
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
let g:terminals_open = []
function OpenTerminalGruvbox()
    if g:colors_name ==# 'gruvbox'
        if &bg ==# 'light'
            let first_word_color = "#a52a2a"
            hi Terminal guibg=#EDE0B9
            hi Terminal guifg=#282828
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
        for buf_num in g:terminals_open
            call term_setansicolors(buf_num, [
                        \"#282828", 
                        \"#CC241D", 
                        \"#8ec07c", 
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
autocmd TerminalOpen * call add(g:terminals_open, buffer_number())  | call OpenTerminalGruvbox() 
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
    command! RA RainbowAlign
    command! Ra RainbowAlign
    command! RS RainbowShrink
    command! Rs RainbowShrink
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
command P Git push -u origin main

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
if has("gui_running") && g:ENABLE_COC && ( g:COC_FILETYPES =~ &filetype )

    au BufNewFile,BufRead * let b:coc_enabled = g:COC_FILETYPES =~ &filetype
    command SpellToggle call CocAction('toggleExtension', 'coc-spell-checker')

    " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    " delays and poor user experience
    "set updatetime=300

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved
    set signcolumn=yes

    " Use <alt-space> to trigger completion.
    inoremap <silent><expr> <C-Space> coc#refresh()
    inoremap <C-@> <C-Space>

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


"ale
if g:ENABLE_ALE
    let g:ale_fixers = {'groovy': ['npm-groovy-lint']}
endif

"copilot
if g:ENABLE_COPILOT
    "disable copilot by default
    let b:copilot_enabled = v:false
    command CopilotToggle let b:copilot_enabled = !b:copilot_enabled
    "let g:copilot_filetypes = {
    "     \ '*': v:false,
    "     \ 'javascript': v:true,
    "     \ }
    "remap <tab> to <C-y>
    imap <silent><script><expr> <C-Y> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:true
endif

"chatgpt
if g:ENABLE_CHATGPT
    let g:openai_api_key='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'
    let g:chat_gpt_max_tokens=2000
    let g:chat_gpt_model='gpt-3.5-turbo'
    let g:chat_gpt_session_mode=0
    let g:chat_gpt_temperature = 0.7
    let g:chat_gpt_lang = 'English'
    let g:chat_gpt_split_direction = 'vertical'
endif

"Download PasteIntoFile.exe from here -> https://github.com/eltos/PasteIntoFile
"Paste images from clipboard to asciidoc file with <leader>p
function! PasteIntoFile(img_name, img_format)
    silent exec "!start PasteIntoFile.exe -d ".shellescape(expand('%:p:h')."\\img")." -f ".shellescape(a:img_name).".".a:img_format." --image-extension=".a:img_format." --autosave=true"
    if a:img_format ==# 'html'
        silent exec "!python -m vim.from_htmlbase64_to_png img\\".a:img_name.".html -o img\\".a:img_name.".png"
        exec "normal! iimage::img/" . a:img_name . ".png[]"
    else
        exec "normal! iimage::img/" . a:img_name . ".".a:img_format."[]"
    endif
    let ipos = getcurpos()
    call setpos('.', ipos)
endfunction
autocmd FileType asciidoc nmap <buffer><silent> <leader>p :call PasteIntoFile(input("Filename:"), input("Format:"))<CR>
