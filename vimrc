syntax on
set nocompatible
set tags+=~/.vim/systags
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
highlight Function cterm=bold,underline ctermbg=red ctermfg=green
highlight TabLine term=underline cterm=bold ctermfg=9 ctermbg=4
highlight TabLineSel term=bold cterm=bold ctermbg=Red ctermfg=yellow
highlight Pmenu ctermbg=darkred
highlight PmenuSel ctermbg=red ctermfg=yellow
set ruler
colorscheme desert
let g:winManagerWindowLayout='FileExplorer|TagList|BufExplorer'
let g:winManagerWidth=35
"let Tlist_Auto_Open=1
"let Tlist_Ctags_Cmd = '/usr/bin/ctags'
"let Tlist_Show_One_File = 1
"let Tlist_Exit_OnlyWindow =  1
"let Tlist_Use_Left_Window = 1
""F7 NERDTree 
map <F3> :NERDTreeToggle<CR>
imap <F3> <ESC>:NERDTreeToggle<CR>
map <F8> :WMToggle<CR>
imap <F8> <ESC>:WMToggle<CR>
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {<CR>}<Esc>O
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap } <c-r>=CloseBracket()<CR>
inoremap " <c-r>=QuoteDelim('"')<CR>
inoremap ' <c-r>=QuoteDelim("'")<CR>

function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

function CloseBracket()
	if match(getline(line('.') + 1), '\s*}') < 0
		return "\<CR>}"
	else
		return "\<Esc>j0f}a"
	endif
endf

function QuoteDelim(char)
	let line = getline('.')
	let col = col('.')
	if line[col - 2] == "\\"
		return a:char
	elseif line[col - 1] == a:char
		return "\<Right>"
	else
		return a:char.a:char."\<Esc>i"
	endif
endf
