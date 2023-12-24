" basic settings
set nocompatible
colorscheme torte
if $TERM == "xterm-256color"
	set t_Co=256
endif
set mouse=nv
set backspace=indent,eol,start
syntax enable
set incsearch
set hlsearch
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType python set expandtab
set hidden " to edit other files while having pending changes on the current
set wildmenu
set wildmode=longest:full,full
set nowrap
set nofoldenable
autocmd FileType c,cpp set foldmethod=indent
" ignore mode changes on virtualbox shared filesystem
autocmd FileChangedShell * if v:fcs_reason != 'mode' | echom 'WARNING: File has changed (' . v:fcs_reason . ')' | endif
" load project specific vimrc
set secure exrc

" when copying from/to clipboard toggle line number and paste
" use the literal terminal keycode for F3 (<ESC>[13~)
nnoremap <silent> <ESC>[13~ :set invnumber invpaste<CR>
set pastetoggle=<ESC>[13~ "for insert mode

" remap 'paste from default register' when in command line mode
cnoremap <C-v> <C-r>"

" don't override default register when pasting in visual mode
xnoremap p pgvy

" scrolling (only few lines at once)
nnoremap <C-u> 10<C-u>
nnoremap <C-d> 10<C-d>

" clear highlighting and lists on escape in normal mode
nnoremap <leader><leader> :windo lcl\|ccl\|noh<return>

" mark 80 column border
set colorcolumn=80
highlight ColorColumn ctermbg=237
autocmd FileType qf setlocal colorcolumn=

" display trailing whitespaces
highlight ExtraWhitespace ctermbg=52
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" indentation
filetype plugin indent on
let g:html_indent_inctags = "html,body,head,tbody"

" toggle display of tabs
set listchars=tab:>-
nnoremap <leader><TAB> :set invlist<cr>

" grep with automatic display in quickfix window
command! -bar -nargs=1 -complete=file Grep
	\ silent execute "grep! -I " . <q-args> | redraw! | cw
cnoreabbrev grep Grep

" diff between splits
command! Difft NERDTreeClose | windo diffthis
cnoreabbrev difft Difft
command! Diffo windo diffoff
cnoreabbrev diffo Diffo

" copy/paste between different instances
vmap <leader>y :w! /tmp/__vimbuf<CR>
nmap <leader>p :r! cat /tmp/__vimbuf<CR>

" close all buffers and open nerdtree
command! Cls NERDTreeClose | %bd | NERDTreeToggle
cnoreabbrev cls Cls

" various object colors
highlight Normal ctermfg=15 ctermbg=236
highlight Search ctermbg=LightBlue
highlight LineNr ctermfg=110 ctermbg=240
highlight Pmenu ctermfg=black ctermbg=grey
highlight PmenuSel ctermfg=white ctermbg=blue
highlight TabLine ctermfg=black ctermbg=yellow
highlight CursorLine ctermfg=black ctermbg=grey
highlight Constant ctermfg=217
highlight Comment ctermfg=33
highlight Special ctermfg=166
highlight Quickfixline ctermfg=0 ctermbg=116
" custom c/c++ operators highlight
highlight COpSep ctermfg=221
autocmd BufWinEnter *.c,*.cpp,*.h,*.hpp
	\ :syntax match COpSep
	\ "\v([\+\-!=%&\|<~])|(/)([/\*])@!|(\*)(/)@!|(\-)@<!(\>)"
	" regex explanation:
	"     \v               : vim regex
	"     ([\+\-!=%&\|<~]) : match any of +  -  !  =  %  &  |  <  ~
	"     (/)([/\*])@!     : match / when not followed by / or *
	"     (\*)(/)@!        : match * when not followed by /
	"     (\-)@<!(\>)      : match > when not preceded by -
" custom c/c++/python separators highlight
highlight CWordSep ctermfg=159
autocmd BufWinEnter *.c,*.cpp,*.h,*.hpp,*.py
	\ :syntax match CWordSep "[(){}\[\]\.,]\|->\|::\|< *\w\+ *>"
	" regex explanation:
	"     [(){}\[\]\.,] : match any of ( ) { } [ ] . ,
	"     ->            : match ->
	"     ::            : match ::
	"     < *\w\+ *>    : match cpp templates (ex. <myclass>)
" custom c/c++ functions highlight
highlight CUserFunction ctermfg=152
autocmd BufWinEnter *.c,*.cpp,*.h,*.hpp
	\ :syntax match CUserFunction
	\ "\v(typedef\s*)@<!(<\h\w*>(\s|\n)*\()"me=e-1,he=e-1
	" regex explanation:
	"     \v               : vim regex
	"     (typedef\s*)@<!  : what comes next must not be preceded by 'typedef '
	"     <\h\w*>          : whole word, head of word followed by word chars
	"     (\s|\n)*\(       : one or more spaces or newlines followed by '('
	"     me=e-1           : exclude from matched text final '('
	"     he=e-1           : exclude from highlighted text final '('
" custom c/c++ function pointers highlight
highlight CUserFunctionPointer ctermfg=152
autocmd BufWinEnter *.c,*.cpp,*.h,*.hpp
	\ :syntax match CUserFunctionPointer
	\ "(\s*\*\s*\h\w*\s*)\(\s\|\n\)*("me=e-1,he=e-1
	" regex explanation:
	"     (\s*\*\s*\h\w*\s*) : to match '( * function_pointer )'
	"     \(\s\|\n\)*(       : one or more spaces or newlines followed by '('
	"     me=e-1             : exclude from matched text final '('
	"     he=e-1             : exclude from highlighted text final '('
" mainly for cscope output when multiple definitions are found
highlight ModeMsg ctermfg=82

" split screen settings
set splitright

"""""""""""""""""""""
"Plugin configuration
"""""""""""""""""""""

" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'Rip-Rip/clang_complete'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'lyuts/vim-rtags'
Plugin 'vim-scripts/ifdef-highlighting'
Plugin 'kien/ctrlp.vim'
Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-commentary'
Plugin 'tmhedberg/SimpylFold'
Plugin 'kawaz/batscheck.vim'
Plugin 'alvan/vim-closetag'
Plugin 'posva/vim-vue'
Plugin 'fatih/vim-go'
call vundle#end()

" jedi vim
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#goto_command = "<leader>g"
let g:jedi#goto_assignments_command = ""
let g:jedi#rename_command = "<leader>r"
let g:jedi#usages_command = "<leader>s"

" airline settings
set noshowmode
let g:airline_theme='bubblegum'
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 0
let airline#extensions#tabline#disable_refresh = 1

" nerdtree mapping
nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['\.pyc$', '\.o$', '__pycache__']

" ctrlp settings
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn|pyc|o))$'
let g:ctrlp_working_path_mode = 'a'

" syntastic settings
let g:syntastic_auto_loc_list = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_config_file = '.syntastic_config'
let g:syntastic_c_config_file = '.syntastic_config'
let g:syntastic_python_checkers = ['pylint']

" clang_complete configuration
inoremap <C-@> <C-x><C-u>
let g:clang_library_path='/usr/lib64/libclang.so'
let g:clang_complete_macros = 1
let g:clang_close_preview = 1
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'

" simplyfold settings
let g:SimpylFold_fold_docstring = 0

" rtags default settings
let g:rtagsUseDefaultMappings = 0
let g:rtagsEnable = 0

" close-tags settings
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" vim-go settings
let g:go_version_warning = 0
let g:go_metalinter_autosave = 1

" settings specific to c/cpp
autocmd FileType c,cpp call SetCOptions()
function SetCOptions()
	let g:rtagsRcCmd = "env -u XDG_RUNTIME_DIR rc"
	let g:rtagsProjects = split(system(g:rtagsRcCmd .
								\ " -w --connect-timeout 100 | cut -d' ' -f1"))
	for prj in g:rtagsProjects
		" check if current directory is a subdirectory of an indexed project
		if expand('%:p') . "/" =~ "^" . prj
			let g:rtagsEnable = 1
			silent execute "!" . g:rtagsRcCmd . " --connect-timeout 100 -w " .
						   \ expand('%:p') . " &> /dev/null"
		elseif $PWD . "/" =~ "^" . prj
			let g:rtagsEnable = 1
			silent execute "!" . g:rtagsRcCmd . " --connect-timeout 100 -w " .
						   \ $PWD . " &> /dev/null"
		endif
	endfor
	if g:rtagsEnable
		" custom 'goto definition' function
		function! RtagsFindSymbols(name)
			silent execute "lcl"
			" check if it's a macro
			let l:pos_before = rtags#getCurrentLocation()
			let args = { '-F' : a:name, '--kind-filter macrodefinition' : '' }
			let results = rtags#ExecuteThen(args,
						\ [[function('rtags#JumpToHandler'),
						\ { 'open_opt' : g:SAME_WINDOW }]])
			let l:pos_after = rtags#getCurrentLocation()
			let l:is_loclist_opened = len(filter(range(1, winnr('$')),
						\ 'getwinvar(v:val, "&buftype") == "quickfix"'))
			if (l:pos_before != l:pos_after) || l:is_loclist_opened
				return
			endif
			" search with definition-only
			let l:pos_before = rtags#getCurrentLocation()
			let args = { '-f' : rtags#getCurrentLocation(),
						\ '--definition-only' : '' }
			let results = rtags#ExecuteThen(args,
						\ [[function('rtags#JumpToHandler'),
						\ { 'open_opt' : g:SAME_WINDOW }]])
			let l:pos_after = rtags#getCurrentLocation()
			let l:is_loclist_opened = len(filter(range(1, winnr('$')),
						\ 'getwinvar(v:val, "&buftype") == "quickfix"'))
			if (l:pos_before != l:pos_after) || l:is_loclist_opened
				return
			endif
			" search by symbol name
			let args = { '-F' : a:name }
			let results = rtags#ExecuteThen(args,
						\ [[function('rtags#JumpToHandler'),
						\ { 'open_opt' : g:SAME_WINDOW }]])
		endfunction

		" custom 'find calls' function
		function! RtagsFindCalls()
			silent execute "lcl"
			let args = { '-r' : rtags#getCurrentLocation() ,
					   \ '--declaration-only' : '' }
			call rtags#ExecuteThen(args, [function('rtags#DisplayResults')])
		endfunction

		"	's'   symbol: find all references to the token under cursor
		"	'g'   global: find global definition(s) of the token under cursor
		"	'c'   calls:  find all calls to the function name under cursor
		"	'r'   rename: rename symbol under cursor
		nnoremap <leader>s :call rtags#FindRefs()<CR>
		nnoremap <leader>g :call RtagsFindSymbols(expand("<cword>"))<CR>
		nnoremap <leader>c :call RtagsFindCalls()<CR>
		nnoremap <leader>r :call rtags#RenameSymbolUnderCursor()<CR>
	elseif has("cscope") " fallback to cscope
		set csto=0
		set cst

		let g:do_cscope_update_on_save = 1
		let g:cscope_db_dir = $HOME . "/.cscope" . $PWD
		let g:cscope_files = g:cscope_db_dir . "/cscope.files"
		let g:cscope_out = g:cscope_db_dir . "/cscope.out"

		if filereadable(g:cscope_out)
			set nocscopeverbose
			silent execute "cs add " . g:cscope_out
			set cscopeverbose
		endif

		"	's'   symbol: find all references to the token under cursor
		"	'g'   global: find global definition(s) of the token under cursor
		"	'c'   calls:  find all calls to the function name under cursor
		"	't'   text:   find all instances of the text under cursor
		"	'e'   egrep:  egrep search for the word under cursor
		"	'f'   file:   open the filename under cursor
		"	'i'   includes: find files that include the filename under cursor
		"	'd'   called: find functions that function under cursor calls
		nnoremap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>
		nnoremap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
		nnoremap <leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
		nnoremap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>

		function! ToggleCscopeUpdate()
			if g:do_cscope_update_on_save == 0
				let g:do_cscope_update_on_save = 1
			else
				let g:do_cscope_update_on_save = 0
			endif
		endfunction

		function! CscopeUpdate()
			if g:do_cscope_update_on_save == 1
				echomsg "Updating cscope database..."
				if !isdirectory(g:cscope_db_dir)
					call mkdir(g:cscope_db_dir, "p")
				endif
				silent cs kill -1
				silent execute "!find . -iname '*.c' -o -iname '*.cpp' " .
							\	"-o -iname '*.h' -o -iname '*.hpp' > " .
							\   g:cscope_files
				silent execute "!cscope -qbRk -I /usr/include -i " .
							\   g:cscope_files . " -f " . g:cscope_out
				set nocscopeverbose
				silent execute "cs add " .  g:cscope_out
				set cscopeverbose
				redraw
			endif
		endfunction
	endif

	" c macro expansion
	if !exists('*ExeExpandCMacro')
	function! ExeExpandCMacro()
		"get current info
		let l:macro_file_name = "__macroexpand__" . tabpagenr()
		let l:file_row = line(".")
		let l:file_name = expand("%")
		let l:file_window = winnr()
		"create mark
		execute "normal! Oint " . l:macro_file_name . ";"
		execute "w"
		"open tiny window ... check if we have already an open buffer for macro
		if bufwinnr(l:macro_file_name) != -1
			execute bufwinnr(l:macro_file_name) . "wincmd w"
			setlocal modifiable
			execute "normal! ggdG"
		else
			execute "bot 5split " . l:macro_file_name
			execute "setlocal filetype=cpp"
			execute "setlocal buftype=nofile"
			nnoremap <buffer> q :q!<CR>
		endif
		" set modifiable
		setlocal modifiable
		"read file with gcc
		if filereadable(g:syntastic_c_config_file)
			let l:gcc_flags = join(readfile(g:syntastic_c_config_file), " ")
		else
			let l:gcc_flags = ""
		endif
		silent! execute "r!gcc " . l:gcc_flags . " -E " . l:file_name
		"keep specific macro line
		if search(l:macro_file_name) != 0
			execute "normal! ggV/int " . l:macro_file_name . ";$\<CR>d"
			execute "normal! jdG"
			"indent
			silent execute "%!indent -st -kr 2> /dev/null"
			execute "normal! gg=G"
			"resize window
			execute "normal! G"
			let l:macro_end_row = line(".")
			execute "resize " . l:macro_end_row
			execute "normal! gg"
		else
			execute "normal! ggdG"
			execute "normal! iERROR: see ':messages' for details\<esc>"
		endif
		"no modifiable
		setlocal nomodifiable
		let l:macro_window = winnr()
		"return to origin place
		execute l:file_window . "wincmd w"
		execute l:file_row
		execute "normal!u"
		execute "w"
		"highlight origin line
		let @/ = getline('.')
		"go back to macro window
		execute l:macro_window . "wincmd j"
		execute "resize 10"
	endfunction
	endif
	if !exists('*ExpandCMacro')
	function! ExpandCMacro()
		if g:rtagsEnable == 0
			" disable cscope update
			let l:backup_do_cscope_update_on_save = g:do_cscope_update_on_save
			let g:do_cscope_update_on_save = 0
		endif
		" expand macro
		call ExeExpandCMacro()
		if g:rtagsEnable == 0
			" restore cscope update
			let g:do_cscope_update_on_save = l:backup_do_cscope_update_on_save
		endif
	endfunction
	endif
	nnoremap <leader>m :call ExpandCMacro()<CR>

	" ifdef highlight plugin
	autocmd BufWinEnter *.c,*.cpp,*.h,*.hpp :source
				        \ ~/.vim/bundle/ifdef-highlighting/syntax/ifdef.vim
endfunction

" settings specific to python
autocmd FileType python call SetPyOptions()
function SetPyOptions()
	nnoremap <leader>e :Grep -r -w -I <C-R>=expand("<cword>")<CR> *<CR>
endfunction

" settings specific to go
autocmd FileType go call SetGoOptions()
function SetGoOptions()
	nnoremap <leader>e :Grep -r -w -I <C-R>=expand("<cword>")<CR> *<CR>
	nnoremap <leader>g :GoDef<CR>
endfunction

" tabline showing modified buffers left behind
hi TabLine ctermfg=113 ctermbg=238 cterm=none
hi TabLineSel ctermfg=238 ctermbg=113 cterm=bold
hi TabLineFill ctermfg=16 ctermbg=113 cterm=bold
function! RenderTabline()
	let l:buffers = filter(range(1, bufnr('$')), 'getbufvar(v:val, "&mod")')
	let l:buffers = filter(l:buffers, '!getbufvar(v:val, "is_being_deleted")')
	" no buffers or only one modified buffer which is currently being
	" displayed
	if (len(l:buffers) == 0) ||
	 \ (len(l:buffers) == 1 && bufnr('%') == l:buffers[0])
		set showtabline=1
		return ""
	endif
	" at least one modified buffer which is not being displayed
	set showtabline=2
	let l:header = "%#TabLine#%SOTHER\ UNSAVED:\ "
	let l:sep = "%#TabLine#%S\ "
	let l:trailer = "%#TabLine#"
	let l:tabline = l:header
	for l:bufnum in l:buffers
		if l:bufnum == bufnr('%')
			continue
		endif
		let l:tabline .= "%#TabLineFill#%(%S[" . l:bufnum . "]%S\ " .
		                 \ fnamemodify(bufname(l:bufnum), ':t') . "\ %)"
		let l:tabline .= l:sep
	endfor
	let l:tabline .= l:trailer
	return l:tabline
endfunction
autocmd BufDelete * call setbufvar(+expand("<abuf>"), "is_being_deleted", 1)
autocmd BufWritePost,BufEnter,BufFilePost,BufDelete *
			\ if (&buftype != "nofile") | let g:tablinestr = RenderTabline()
			\ | set tabline=%!g:tablinestr | endif

"""""""""""""""""""""""""""""""""
" project specific configurations
"""""""""""""""""""""""""""""""""

if filereadable("README") && system("head -c 12 README") == "Linux kernel"
	" restore tab to 8 char
	set tabstop=8
	set softtabstop=8
	set shiftwidth=8
	" syntastic overrides
	let g:syntastic_c_checkers = ['checkpatch']
	let g:syntastic_auto_loc_list = 0
	" clang_complete overrides
	let g:clang_complete_loaded = 0
else
	" update cscope db on save
	if has("cscope") && g:rtagsEnable == 0
		autocmd BufWritePost *.c,*cpp,*.h,*.hpp call CscopeUpdate()
		" map key to toggle cscope update
		" use the literal terminal keycode for F4 (<ESC>[14~)
		noremap <ESC>[14~ :call ToggleCscopeUpdate()<CR>
	endif
endif

