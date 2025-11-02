" ------------------------------------------------------------
"                   Personal Vim Configuration
" ------------------------------------------------------------

" General -----------------------------------------------------
set nocompatible
set history=700
set autoread
set hidden
set so=7
let mapleader = ","
let g:mapleader = ","
filetype plugin indent on
syntax on

" UI ----------------------------------------------------------
set number
set ruler
set cmdheight=2
set laststatus=2
set splitright
set wildmenu
set wildignore=*.o,*.pyc,*.swp,*.class,*.DS_Store
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set lazyredraw
set magic

" Indentation & Formatting ------------------------------------
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set ai
set si
set wrap
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search ------------------------------------------------------
set ignorecase
set smartcase
set hlsearch
set incsearch

" Key Mappings ------------------------------------------------
nnoremap <leader>w :w!<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq!<CR>

nnoremap <silent> <leader><CR> :nohlsearch<CR>

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>ba :bufdo bdelete<CR>

nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove

nnoremap <leader>te :tabedit <C-r>=expand('%:p:h')<CR>/

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

nnoremap <Space> /
nnoremap <C-Space> ?

nnoremap j gj
nnoremap k gk
nnoremap <S-Left> b
nnoremap <S-Right> e

" Visual selection search helper --------------------------------
function! VisualSelection(direction) abort
  let l:save_reg = @"
  let l:save_type = getregtype('"')
  normal! gv"vy
  let l:pattern = escape(@", '\/.*$^~[]')
  let @/ = l:pattern
  if a:direction ==# 'b'
    execute 'normal! ?' . l:pattern . "\<CR>"
  else
    execute 'normal! /' . l:pattern . "\<CR>"
  endif
  call setreg('"', l:save_reg, l:save_type)
endfunction

xnoremap <silent> * :<C-U>call VisualSelection('f')<CR>
xnoremap <silent> # :<C-U>call VisualSelection('b')<CR>

" Plugin Management -------------------------------------------
call plug#begin('~/.vim/plugged')

" Linting & formatting
Plug 'dense-analysis/ale'

" LSP & completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Navigation & fuzzy finding
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Editing helpers
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-fugitive'
Plug 'puremourning/vimspector'

" AI assistance
Plug 'github/copilot.vim'
Plug 'madox2/vim-ai'

call plug#end()

if empty(filter(values(g:plugs), 'isdirectory(v:val.dir)'))
  augroup PlugBootstrap
    autocmd!
    autocmd VimEnter * ++once nested PlugInstall --sync | source $MYVIMRC
  augroup END
endif

" ALE ---------------------------------------------------------
let g:ale_fixers = {
\   'python': ['remove_trailing_lines', 'trim_whitespace', 'pycln', 'black'],
\   'javascript': ['prettier', 'eslint'],
\   'typescriptreact': ['prettier', 'eslint'],
\}
let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 1
let g:ale_completion_autoimport = 1
if executable('python3')
  let g:python3_host_prog = exepath('python3')
endif
let g:ale_python_pyright_executable = 'pyright-langserver'
let g:ale_python_pyright_use_global = 1
let g:ale_python_pyright_use_project_root = 1
let g:ale_linters = {'python': ['pyright']}

nnoremap <leader>l :ALEFix<CR>
nnoremap <leader>en :ALEEnable<CR>
nnoremap <leader>di :ALEDisable<CR>

" Coc.nvim ----------------------------------------------------
let g:coc_global_extensions = ['coc-pyright', 'coc-json', 'coc-tsserver', 'coc-yaml']

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> <leader>jd <Plug>(coc-definition)

nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> <leader>jt <Plug>(coc-type-definition)

nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> <leader>ji <Plug>(coc-implementation)

nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>jr <Plug>(coc-references)

nnoremap <leader>rn <Plug>(coc-rename)
nnoremap <leader>ca <Plug>(coc-codeaction-selected)
xnoremap <leader>ca <Plug>(coc-codeaction-selected)
command! -nargs=0 Format :call CocActionAsync('format')

" FZF helpers -------------------------------------------------
function! s:project_root() abort
  let l:root = finddir('.git', '.;')
  return empty(l:root) ? getcwd() : fnamemodify(l:root, ':h')
endfunction

function! s:rg(scope, args) abort
  let l:dir = a:scope ==# 'root' ? s:project_root() : getcwd()
  let l:query = empty(a:args) ? "''" : shellescape(a:args)
  let l:cmd = 'rg --hidden --glob "!.git" --glob "!.cache" --glob "!*.min.js" --glob "!dist" --glob "!build" --glob "!node_modules" --column --line-number --no-heading --color=always '
  call fzf#vim#grep(l:cmd . l:query, 1, {'dir': l:dir})
endfunction

command! -nargs=* Rg call s:rg('cwd', <q-args>)
command! -nargs=* RgRoot call s:rg('root', <q-args>)
command! FilesRoot execute 'Files ' . fnameescape(s:project_root())

nnoremap <leader>sf :Files<CR>
nnoremap <leader>sF :FilesRoot<CR>
nnoremap <leader>sg :Rg<Space>
nnoremap <leader>sG :RgRoot<Space>

" NERDTree ----------------------------------------------------
nnoremap <leader>nt :NERDTreeToggle<CR>
autocmd VimEnter * if !argc() | NERDTree | wincmd p | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Vimspector --------------------------------------------------
let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>
nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>
nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver

" Copilot / AI ------------------------------------------------
let g:openai_model = 'gpt-4o-mini'

" Autocommands ------------------------------------------------
autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"" | endif

" Buffer persistence
set viminfo^=%
