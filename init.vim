" basic
syntax on
set number
"set colorcolumn=100
"set mouse=a

" vim-plug
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'fatih/vim-go'
Plug 'mdempsky/gocode'
Plug 'majutsushi/tagbar'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'zchee/deoplete-jedi'
Plug 'kien/ctrlp.vim'
Plug 'edkolev/tmuxline.vim'
call plug#end()

filetype plugin indent on
filetype plugin on

" gb setting
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1

" gruvbox
set background=dark
set termguicolors
let g:gruvbox_italic=1
colorscheme gruvbox

" airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0

map <leader>= :tabn<CR>
map <leader>- :tabp<CR>

" tagbar
map <F9> :TagbarToggle<CR>
let g:tagbar_width = 22

" nerdtree
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeWinPos='left'
let NERDTreeWinSize=22
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>


"deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#source_importer = 1
let g:deoplete#sources#go#auto_goos = 1 
let g:deoplete#sources#go#pointer = 1 

" deoplete-go settings
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'

augroup go
  autocmd!
"" Show by default 4 spaces for a tab
autocmd BufNewFile,BufRead *.go,*.php,*.py setlocal noexpandtab tabstop=4 shiftwidth=4

" check fix at save go
autocmd BufWritePost *.go :GoMetaLinter

augroup END

map ss :w<CR>
map se :wq!<CR>

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
