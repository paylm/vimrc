
call plug#begin('~/.local/share/nvim/plugged')
Plug 'fatih/vim-go'
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go'
Plug 'junegunn/fzf.vim'
Plug 'mdempsky/gocode'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'danielsiepmann/neotags'
" Initialize plugin system
call plug#end()

execute pathogen#infect()
filetype plugin indent on 
syntax enable

filetype plugin on

set nocompatible
set nu
set autoindent
set shiftwidth=4
set ignorecase
set cindent
set hls is
set hlsearch
set ts=4
set history=100
set syntax=c
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically read changed files
set autoindent                  " Enabile Autoindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set noerrorbells                " No beeps"
set noshowmatch                 " Do not show matching brackets by flickering
set noshowmode                  " We show the mode with airline or lightline
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not it begins with upper case
set completeopt=menu,menuone    " Show popup menu, even if there is one entry
set pumheight=10                " Completion window max size
set mouse=a

" vim go 
" let g:go_fmt_autosave = 0

let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
let g:go_term_mode = "split"
let g:go_term_height = 20
let g:go_term_width = 10

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_operators = 1

"Use deoplete.
"neocomplete like
set completeopt+=noinsert
" deoplete.nvim recommend
set completeopt+=noselect

"
" Path to python interpreter for neovim
let g:python3_host_prog  = '/usr/bin/python3'
" Skip the check of neovim module
let g:python3_host_skip_check = 1
"
" Run deoplete.nvim automatically
let g:deoplete#enable_at_startup = 1
"let g:deoplete#auto_complete_delay = 80
" deoplete-go settings
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#source_importer = 1
let g:deoplete#sources#go#auto_goos = 1 
let g:deoplete#sources#go#pointer = 1 


"fzf 
map ff :Files<CR>
map fb :Buffers<CR>



" Open :GoDeclsDir with ctrl-g
nmap <C-g> :GoDeclsDir<cr>
imap <C-g> <esc>:<C-u>GoDeclsDir<cr>
"
"
augroup go
  autocmd!
"
"" Show by default 4 spaces for a tab
autocmd BufNewFile,BufRead *.go,*.php,*.py setlocal noexpandtab tabstop=4 shiftwidth=4

" :GoBuild and :GoTestCompile
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

" :GoTest
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" :GoRun
autocmd FileType go nmap <leader>r  <Plug>(go-run)

" :GoDoc
autocmd FileType go nmap <Leader>d <Plug>(go-doc)

" :GoCoverageToggle
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

" :GoInfo
autocmd FileType go nmap <Leader>i <Plug>(go-info)

" :GoMetaLinter
autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

" :GoDef but opens in a vertical split
autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
" :GoDef but opens in a horizontal split
autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

" :GoAlternate  commands :A, :AV, :AS and :AT
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0,'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0,'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0,'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0,'tabe')
" check fix at save go
autocmd BufWritePost *.go :GoMetaLinter


	augroup END

" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
	let l:file = expand('%')
	if l:file =~#
		'^\f\+_test\.go$'
		call
		go#test#Test(0, 1)
	elseif l:file
		=~#
		'^\f\+\.go$'
		call
		go#cmd#Build(0)
	endif
endfunction

" other setting
""""""""""""""""""""""""""""""
" scrooloose/nerdtree setting
" """"""""""""""""""""""""""""""
let NERDTreeWinPos='left'
let NERDTreeWinSize=22

let g:tagbar_width = 28
let g:tagbar_autopreview = 1

set ruler
colorscheme desert
let g:winManagerWindowLayout='FileExplorer|TagList|BufExplorer'
let g:winManagerWidth=35


""F3 NERDTree 
map <F3> :NERDTreeToggle<CR>
imap <F3> <ESC>:NERDTreeToggle<CR>
nmap <F9> :TagbarToggle<CR>
imap <F9> <ESC>:TagbarToggle<CR>
map ss :w<CR>
map se :wq!<CR>

"run script by  sr (save and run)"
map sr :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		exec "!time python %"
	elseif &filetype == 'html'
		exec "!firefox % &"
	elseif &filetype == 'go'
		"        exec "!go build %<"
		exec "!time go run %"
	elseif &filetype == 'mkd'
		exec "!~/.vim/markdown.pl% > %.html &"
		exec "!firefox %.html&"
	endif
endfunc
