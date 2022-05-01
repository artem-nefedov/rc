try
	call plug#begin()
catch
	let s:no_plug_manager=1
endtry

let g:mapleader = ','

if !exists('s:no_plug_manager')
	"let g:netrw_nogx = 1
	" Plug 'artem-nefedov/netrw'
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'tpope/vim-dispatch'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-vinegar'
	Plug 'tpope/vim-unimpaired'
	let g:rainbow_active = 0
	Plug 'luochen1990/rainbow'
	Plug 'tyru/open-browser.vim'
	Plug 'scrooloose/nerdcommenter'
	Plug 'PProvost/vim-ps1'
	Plug 'udalov/kotlin-vim'
	Plug 'airblade/vim-gitgutter'
	Plug 'mbbill/undotree'
	Plug 'easymotion/vim-easymotion'
	Plug 'majutsushi/tagbar'
	let g:airline#extensions#bufferline#enabled = 0
	let g:airline#extensions#term#enabled = 0
	Plug 'vim-airline/vim-airline'
	Plug 'junegunn/vim-easy-align'
	Plug 'junegunn/gv.vim'
	"Plug 'junegunn/vim-peekaboo'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'artem-nefedov/vim-docker-tools', { 'on': 'DockerToolsOpen' }
	let g:maximizer_set_default_mapping = 0
	Plug 'szw/vim-maximizer'
	Plug 'moll/vim-bbye'
	Plug 'aymericbeaumet/symlink.vim'
	let g:terraform_align = 1
	Plug 'hashivim/vim-terraform'
	Plug 'junegunn/goyo.vim'

	" with coc-vim, we don't need vim-go highlighting
	let g:go_highlight_diagnostic_errors = 0
	let g:go_highlight_diagnostic_warnings = 0
	let g:go_term_enabled = 1
	let g:go_term_close_on_exit = 0
	let g:go_gopls_enabled = 0 " use gopls with coc-vim
	let g:go_fmt_autosave = 0  " breaks gopls+coc-vim on save
	let g:go_doc_keywordprg_enabled = 0 " do not map K to GoDoc (doesn't work)
	let g:go_def_mapping_enabled = 0 " fix ctrl-t

	Plug 'fatih/vim-go'
	"Plug 'bling/vim-bufferline'
	if (v:version >= 800) || has('nvim')
		Plug 'w0rp/ale'
		nnoremap <Space>a :ALENextWrap<CR>
		nnoremap <Space>q :ALEPreviousWrap<CR>
	endif
	if has('nvim')
		Plug 'artem-nefedov/nvim-editcommand'
		" Plug 'hkupty/nvimux'
		Plug 'artem-nefedov/nvimux' " fix esc undefined
		Plug 'neoclide/coc.nvim', {'branch': 'release'}

		set shortmess+=c

		function! s:check_back_space() abort
			let col = col('.') - 1
			return !col || getline('.')[col - 1]  =~# '\s'
		endfunction

		inoremap <silent><expr> <tab>
					\ pumvisible() ? "\<c-n>" :
					\ <sid>check_back_space() ? "\<tab>" :
					\ coc#refresh()
		inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

		if exists('*complete_info')
			inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
		else
			inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
		endif

		nmap <silent> gd <Plug>(coc-definition)
		nmap <silent> gy <Plug>(coc-type-definition)
		" nmap <silent> gi <Plug>(coc-implementation)
		nmap <silent> gr <Plug>(coc-references)

		" Use K to show documentation in preview window.
		nnoremap <silent> K :call <SID>show_documentation()<CR>

		function! s:show_documentation()
			if (index(['vim','help'], &filetype) >= 0)
				execute 'h '.expand('<cword>')
			elseif (coc#rpc#ready())
				call CocActionAsync('doHover')
			else
				execute '!' . &keywordprg . " " . expand('<cword>')
			endif
		endfunction

		" Highlight the symbol and its references when holding the cursor.
		augroup cocvim
			au!
			au CursorHold * silent call CocActionAsync('highlight')
			" Setup formatexpr specified filetype(s).
			au FileType typescript,json setl formatexpr=CocAction('formatSelected')
			" Update signature help on jump placeholder.
			au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
		augroup end

		" Symbol renaming.
		nmap <leader>rn <Plug>(coc-rename)

		" Formatting selected code.
		xmap <leader>f  <Plug>(coc-format-selected)
		nmap <leader>f  <Plug>(coc-format-selected)

		" Map function and class text objects
		" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
		xmap if <Plug>(coc-funcobj-i)
		omap if <Plug>(coc-funcobj-i)
		xmap af <Plug>(coc-funcobj-a)
		omap af <Plug>(coc-funcobj-a)
		xmap ic <Plug>(coc-classobj-i)
		omap ic <Plug>(coc-classobj-i)
		xmap ac <Plug>(coc-classobj-a)
		omap ac <Plug>(coc-classobj-a)

		" Use CTRL-S for selections ranges.
		" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
		nmap <silent> <C-s> <Plug>(coc-range-select)
		xmap <silent> <C-s> <Plug>(coc-range-select)

		" Add `:Format` command to format current buffer.
		command! -nargs=0 Format :call CocAction('format')

		" Add `:Fold` command to fold current buffer.
		command! -nargs=? Fold :call CocAction('fold', <f-args>)

		" Add `:OR` command for organize imports of the current buffer.
		command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

		nmap <Space>s <Plug>(coc-diagnostic-next)
		nmap <Space>w <Plug>(coc-diagnostic-prev)
	else
		let g:SuperTabDefaultCompletionType = "<c-n>"
		Plug 'ervandew/supertab'
	endif
	call plug#end()

	nnoremap <space>b :Gblame<cr>

	"nmap gx <Plug>(openbrowser-smart-search)
	"vmap gx <Plug>(openbrowser-smart-search)
	nmap gx <Plug>(openbrowser-open)
	vmap gx <Plug>(openbrowser-open)
	" map <Plug>NetrwBrowseX instead for compatibility with fugitive?

	augroup plugins
		au!
		au FileType go nnoremap <buffer> <expr> <space>r ":\<c-u>call Golang_R('" . airline#extensions#tagbar#currenttag() . "')\<cr>"
		au FileType python ALEDisableBuffer
	augroup END

	if has('nvim')
		lua << EOF
		-- Nvimux configuration
		local nvimux = require('nvimux')
		nvimux.setup{
			config = {
				prefix = '<C-x>',
				new_window = 'term',
				new_tab = 'term',
			},
			bindings = {}
		}
EOF

		let g:editcommand_prompt = '➜'
		set scrollback=-1
		nnoremap <c-x>z :MaximizerToggle<cr>:AirlineRefresh<cr>
		tmap <c-x>z <c-\><c-n><c-x>zi
		nnoremap <c-x>Z :call Super_Zoom()<cr>
		tmap <c-x>Z <c-\><c-n><c-x>Z
		tmap <c-x><c-h> <c-x>h
		tmap <c-x><c-j> <c-x>j
		tmap <c-x><c-k> <c-x>k
		tmap <c-x><c-l> <c-x>l
		" <c-x><c-l> maps to <c-x>l in nvimux, and so on
		nmap <c-x><c-h> <c-x>h
		nmap <c-x><c-j> <c-x>j
		nmap <c-x><c-k> <c-x>k
		nmap <c-x><c-l> <c-x>l
		tmap <c-x><left> <c-x>h
		tmap <c-x><down> <c-x>j
		tmap <c-x><up> <c-x>k
		tmap <c-x><right> <c-x>l
		nmap <c-x><left> <c-x>h
		nmap <c-x><down> <c-x>j
		nmap <c-x><up> <c-x>k
		nmap <c-x><right> <c-x>l
		tnoremap <c-o> <c-\><c-n>
		tnoremap <c-x><c-x> <c-\><c-n>
		tnoremap <c-x>. <c-x>
		nnoremap <c-x><c-d> :call DeleteHiddenBuffers()<cr>
		nnoremap <c-x><c-s> :silent !test \\! -f ~/.vim-session \|\| mv ~/.vim-session ~/.vim-session.prev<cr>:call DeleteHiddenBuffers() \| mksession! ~/.vim-session<cr>
		tmap <c-x><c-s> <c-\><c-n><c-x><c-s>i
		nnoremap <c-x><c-r> :source ~/.vim-session \| call Terminal_restore()<cr>
		tmap <c-x><c-r> <c-\><c-n><c-x><c-r>i
		tnoremap <c-x><pageup> <c-\><c-n><pageup>
		tmap <c-x><c-n> <c-x>n
		tmap <c-x><c-p> <c-x>p
		nmap <c-x><c-n> <c-x>n
		nmap <c-x><c-p> <c-x>p
		imap <c-x><c-n> <c-x>n
		imap <c-x><c-p> <c-x>p

		" close window in all modes
		tnoremap <c-x><c-w> <c-\><c-n><c-w>q
		inoremap <c-x><c-w> <esc><c-w>q
		vnoremap <c-x><c-w> <esc><c-w>q
		nnoremap <c-x><c-w> <c-w>q

		tnoremap <c-x>: <c-\><c-n>:
		inoremap <c-x>: <esc>:
		tnoremap <c-x>; <c-\><c-n>q:
		inoremap <c-x>; <esc>qa:
		nnoremap <c-x>t :tabnew<cr>
		tmap <c-x>t <c-\><c-n><c-x>t
		imap <c-x>t <esc><c-x>t
		nnoremap <c-x>0 :tabl<cr>
		tmap <c-x>0 <c-\><c-n><c-x>0
		imap <c-x>0 <esc><c-x>0
		nnoremap <c-x>I :PlugInstall<cr>
		nnoremap <c-x>U :PlugUpgrade \| PlugUpdate<cr>
		nnoremap <c-x><c-e> :exec "if exists('w:nvr_term') \|
					\ exec 'b ' . w:nvr_term \|
					\ startinsert \| else \|
					\ echo 'No bound terminal' \| endif"<cr>
		tmap <c-x>y <c-\><c-n>GkV?➜<cr>j"*y<c-l>i
		tmap <c-x>Y <c-\><c-n>GkV?➜<cr>jy<c-l>i
		nmap <c-x>y "*y
		nmap <c-x>Y "*Y
		vmap <c-x>y "*y
		nnoremap <c-x><c-y> :let @* = @"<cr>
		nnoremap <c-x>/ :let @* = @/<cr>
		nmap <c-x>* g*<c-x>/
		nmap <c-x>g gJ"*yy
		vmap <c-x>g gJ"*yy
		tnoremap <c-x>b <c-\><c-n>:call chansend(b:terminal_job_id, Get_git_branch(0)) \| startinsert<cr>

		function! Terminal_enter()
			let b:allow_git_refresh = 1
			exec 'lcd ' . b:terminal_pwd
		endfunction

		augroup Term
			au!
			au Filetype netrw vmap <buffer> E .call feedkeys("i<end>\<lt>c-a>") \| term<cr>
			au Filetype netrw nmap <buffer> E VE
			au BufReadPre,FileReadPre * call InheritExitRemap()
			au FileType netrw call InheritExitRemap()
			au WinEnter  term://* stopinsert
			au TermEnter term://*/zsh call Terminal_enter()
			au TermLeave term://*/zsh let b:allow_git_refresh = 0
			au TermOpen  term://*/zsh call Terminal_init()
		augroup END

		function! Get_git_branch(force)
			if ( exists('b:allow_git_refresh') && b:allow_git_refresh ) || a:force
				let b:last_read_git_branch = systemlist('git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo --')[0]
				return b:last_read_git_branch
			else
				return exists('b:last_read_git_branch') ? b:last_read_git_branch : '--'
			endif
		endfunction

		function! Terminal_airline(...)
			if &buftype == 'terminal'
				let l:spc = g:airline_symbols.space
				call a:1.add_section('airline_a', l:spc . g:airline_section_a . l:spc)
				call a:1.add_section('airline_b', l:spc . "%{Get_git_branch(0)}" . l:spc)
				call a:1.add_section('airline_c', l:spc . '%{fnamemodify(getcwd(), ":~:.")}')
				call a:1.split()
				call a:1.add_section('airline_y', "%{airline#util#wrap('" . l:spc . l:spc . "' . matchstr(expand('%'), 'term.*:\\zs.*') . '" . l:spc . "', 80)}")
				call a:1.add_section('airline_z', l:spc . airline#section#create_right(['linenr', 'maxlinenr']))
				return 1
			endif
		endfunction

		if !exists('g:airline_terminal_function_added')
			call airline#add_statusline_func('Terminal_airline')
			let g:airline_terminal_function_added = 1
		endif

		" hack fix for TERM=putty
		if $TERM == 'putty-256color' && empty(maparg("<s-left>", 'n'))
			noremap  <s-left>  <c-left>
			noremap  <s-right> <c-right>
			noremap! <s-left>  <c-left>
			noremap! <s-right> <c-right>
			tnoremap <s-left>  <c-left>
			tnoremap <s-right> <c-right>
		endif
	endif

	command! -bang -nargs=* GGrep
		\ call fzf#vim#grep(
		\   'git grep --line-number --color=always '.shellescape(<q-args>), 0,
		\   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

	command! -bang -nargs=* Rg
		\ call fzf#vim#grep(
		\   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(substitute(substitute(<q-args>, '\\>$', '\\b', ''), '^\\<', '\\b', '')), 1,
		\   fzf#vim#with_preview(), <bang>0)

	set list
	let g:NERDDefaultAlign = 'left'
	let g:NERDSpaceDelims = 1
	let g:ale_lint_on_enter = 0
	let g:ale_lint_delay = 1000
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
	let g:airline#extensions#keymap#enabled = 0
	let g:netrw_keepdir = 0

	nnoremap <leader>r :RainbowToggle<cr>
	nnoremap <leader>u :UndotreeToggle<CR>
	nnoremap gs :Git<CR>
	nnoremap <leader>gd :Gvdiff<CR>
	nnoremap <leader>t :TagbarToggle<CR>
	nmap Q <Plug>(easymotion-s)

	" Start interactive EasyAlign in visual mode (e.g. vipga)
	xmap ga <Plug>(EasyAlign)
	" Start interactive EasyAlign for a motion/text object (e.g. gaip)
	nmap ga <Plug>(EasyAlign)

	nnoremap <c-p>f :Files<CR>
	nmap <c-p><c-p> <c-p>f
	nnoremap <c-p>g :GFiles<CR>
	nnoremap <c-p>c :BCommits<CR>
	nnoremap <c-p>C :Commits<CR>
	nnoremap <c-p>w :Windows<CR>
	nnoremap <c-p>b :Buffers<CR>
	nnoremap <c-p>l :BLines<CR>
	nnoremap <c-p>L :Lines<CR>
	nnoremap <c-p>: :History:<CR>
	nmap <c-p>; <c-p>:
	nnoremap <c-p>/ :History/<CR>
	nmap <c-p>? :History/<CR>
	nnoremap <c-p>r :Rg<space>
	nnoremap <c-p><c-r> :Rg <c-r>/
	nnoremap <c-p>G :GGrep<space>

	highlight GitGutterAdd    guifg=#009900 guibg=#073642 ctermfg=2 ctermbg=0
	highlight GitGutterChange guifg=#bbbb00 guibg=#073642 ctermfg=3 ctermbg=0
	highlight GitGutterDelete guifg=#ff2222 guibg=#073642 ctermfg=1 ctermbg=0
else
	filetype plugin indent on
	nnoremap Q <nop>
endif

function! Golang_R(fname)
	if expand('%') =~# '._test\.go$'
		if a:fname =~# '^Test[[:upper:]].*()$'
			GoTestFunc
		else
			GoTest
		endif
	else
		GoRun
	endif
endfunction

function! Tags_regenerate_done(...)
	if a:2 == 0
		echom 'Done re-generating tags'
	else
		echohl WarningMsg
		echom 'ctags exited with code ' . a:2
		echohl NONE
	endif
endfunction

function! Tags_regenerate()
	let l:cwd = getcwd()

	while 1
		if isdirectory('.git')
			break
		endif

		lcd ..

		if getcwd() == '/'
			echohl WarningMsg
			echo 'Could not find git root'
			echohl NONE
			silent exec 'lcd ' . l:cwd
			return
		endif
	endwhile

	echom 'Started re-generating tags in ' . getcwd()
	call jobstart('ctags --tag-relative=yes --exclude=.git -R -f .git/tags .', {'on_exit': 'Tags_regenerate_done'})

	if &buftype == 'terminal'
		silent exec 'lcd ' . l:cwd
	endif
endfunction

function! Run_File(args)
	write
	vsplit
	exec 'terminal %:p ' . a:args
	wincmd p
endfunction

function! Go_Back(write)
	if a:write == 1 && &readonly != 1
		write
	endif
	if &bufhidden == 'delete' || &bufhidden == 'wipe'
		q!
	else
		exec "b! " . b:nvr_jump
	endif
endfunction

function! InheritExitRemap()
	if exists('b:nvr_jump')
		return
	endif
	try
		let l:altbuf = bufnr('#')
		let b:nvr_jump = l:altbuf
		nnoremap <buffer> ZQ :call Go_Back(0)<cr>
		nnoremap <buffer> ZZ :call Go_Back(1)<cr>
	catch
	endtry
endfunction

function! Unmap_Z()
	try
		nunmap <buffer> ZQ
		nunmap <buffer> ZZ
	catch
	endtry
endfunction

nnoremap <c-x>> :<c-u>call Tab_Move('+')<cr>
nnoremap <c-x>< :<c-u>call Tab_Move('-')<cr>

function! Tab_Move(sign)
	if a:sign == '-'
		let l:shift = tabpagenr() - 1
		let l:key = '<'
	else
		let l:shift = tabpagenr('$') - tabpagenr()
		let l:key = '>'
	endif

	if v:count1 < l:shift
		let l:shift = v:count1
	endif

	if l:shift != 0
		exec 'tabm ' . a:sign . l:shift
	endif

	silent! call repeat#set("\<c-x>" . l:key, v:count1)
endfunction

function! Super_Zoom()
	let l:curline = line('.')
	tabe %
	exec l:curline
	setlocal nolist nonumber norelativenumber
	GitGutterBufferDisable
	augroup Super_Zoom
		au!
		au TabLeave * GitGutterBufferEnable | au! Super_Zoom
	augroup END
endfunction

function! MyExpandTab(...)
	if exists('a:1') && a:1 > 0
		setlocal expandtab
		execute 'setlocal shiftwidth='.a:1
		execute 'setlocal softtabstop='.a:1
	else
		setlocal expandtab!
		setlocal shiftwidth=0
		setlocal softtabstop=0
	endif
endfunction

function! GoToWindowByBuffer(count)
	if a:count && bufexists(a:count)
		for l:win_id in win_findbuf(a:count)
			call win_gotoid(l:win_id)
			return
		endfor
		tabnew
		exec 'b ' . a:count
	else
		throw 'No such buffer: ' . a:count
	endif
endfunction

nnoremap <expr> <c-x>b ":\<c-u>call GoToWindowByBuffer(" . (v:count ? v:count . ")\<cr>" : ")\<left>")

function! DeleteHiddenBuffers()
	let tpbl=[]
	call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
	for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
		silent execute 'bwipeout!' buf
	endfor
endfunction

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
inoremap <C-Space> <C-^>
cnoremap <C-Space> <C-^>
set langremap
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

noremap <S-y> y$
set hlsearch
nnoremap <F2> :%s///gn<left><left><left><left>
nnoremap <F3> :vimgrep  % \| copen
			\<left><left><left><left><left><left>
			\<left><left><left><left>
set pastetoggle=<F4>
nnoremap <F5> :call MyExpandTab(2)
nnoremap <F6> :call MyExpandTab(4)
nnoremap <F8> :setlocal spell! spelllang=en_us \| syntax spell toplevel<cr>
nnoremap <F9> :w! /tmp/vim-exec \| !chmod +x /tmp/vim-exec && /tmp/vim-exec  && rm -f /tmp/vim-exec
			\<left><left><left><left><left><left><left><left><left><left><left><left>
			\<left><left><left><left><left><left><left><left><left><left><left>
nnoremap <F10> :wa \| !git ci -m '' && git svn dcommit<left><left><left><left><left>
			\<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>
nnoremap ZA :qa<CR>
nnoremap ; q:i
nnoremap <C-w>e     :tab split<CR>
nnoremap <C-w><C-e> :tab split<CR>
nnoremap <leader>w :windo setlocal wrap!<CR>
nnoremap <leader>b :call OpenInTabAndGoBack()<cr>
nnoremap <leader>F :let @" = expand("%")<cr>
nnoremap <c-x><c-a> <c-a>
nnoremap <Space><Space> @q
nnoremap <Space>d "_dd
vnoremap <Space>d "_d
nnoremap <space>r :echo 'Not runnable file'<cr>
nmap <space>R <space>r
nnoremap <space>m :make<cr>
nnoremap <space>t :TagbarOpen fj<cr>
nnoremap <space>T :<c-u>call Tags_regenerate()<cr>

" make :W equal to :w
command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>

set timeoutlen=3000

if &diff
	nnoremap <leader>1 :diffget LOCAL<CR>
	nnoremap <leader>2 :diffget BASE<CR>
	nnoremap <leader>3 :diffget REMOTE<CR>
endif

set colorcolumn=80
set mouse=a
set background=dark
set number
set relativenumber
set tabpagemax=100
set splitbelow
set splitright
" set spell spelllang=en_us

if has("nvim-0.5.0") || has("patch-8.1.1564")
	" Recently vim can merge signcolumn and number column into one
	set signcolumn=number
endif

" emacs-like shortcuts for insert/command mode (and some for normal)
nnoremap <c-a> ^
"nnoremap <c-e> $
nnoremap <m-d> cw
inoremap <m-d> <esc><right>dWi
cnoremap <c-a> <home>
" <c-e> is already equal to <end> in cmd mode
inoremap <c-a> <c-o>^
inoremap <c-e> <end>
inoremap <c-_> <c-o>u
inoremap <c-k> <Esc>lDa
inoremap <c-u> <Esc>d0xi
cnoremap <c-k> <c-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>
" <c-u> is already 'delete to 0' in cnd mode
nnoremap <m-f> <c-right>
vnoremap <m-f> <c-right>
cnoremap <m-f> <c-right>
inoremap <m-f> <c-right>
nnoremap <m-b> <c-left>
vnoremap <m-b> <c-left>
cnoremap <m-b> <c-left>
inoremap <m-b> <c-left>

function! OpenInTabAndGoBack()
	let l:curtab = tabpagenr()
	tabe %
	exec l:curtab . 'tabn'
endfunction

function! NetrwOpenMultiTab(...) range
	let l:n_lines =  a:lastline - a:firstline + 1
	let l:command = 'normal '
	let l:i = 1

	while l:i < l:n_lines
		let l:command .= 'tgT:' . ( a:firstline + l:i ) . "\<CR>:+tabmove\<CR>"
		let l:i += 1
	endwhile
	let l:command .= 'tgT'

	" Restore the Explore tab position.
	if l:i != 1
		let l:command .= ':tabmove -' . ( l:n_lines - 1 ) . "\<CR>"
	endif

	" Check function arguments
	if a:0 > 0
		if a:1 > 0 && a:1 <= l:n_lines
			" The current tab is for the nth file.
			let l:command .= ( tabpagenr() + a:1 ) . 'gt'
		else
			" The current tab is for the last selected file.
			let l:command .= ( tabpagenr() + l:n_lines ) . 'gt'
		endif
	else
		" Goto original line if called with Shift
		let l:command .= ':' . a:firstline . "\<CR>"
	endif
	" The current tab is for the Explore tab by default.

	execute l:command
	"echom command
endfunction

"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_winsize = 25
"nnoremap <leader>e :Explore<CR>
"nnoremap <leader>d :Vexplore<CR>

function! Terminal_modify(ncmd)
	setlocal modifiable
	silent nunmap <buffer> J
	silent vunmap <buffer> J
	silent nunmap <buffer> gJ
	silent vunmap <buffer> gJ
	exec 'norm ' . a:ncmd
endfunction

function! Terminal_regsub()
	let l:newval = substitute(@", '^➜ ', '', '')
	let @" = substitute(l:newval, '\n$', '', '')
endfunction

function! Terminal_init()
	let w:nvr_term = bufnr('%')
	let b:terminal_pwd = getcwd()
	setlocal sidescrolloff=0
	setlocal scrolloff=0
	nmap <buffer> o i
	nmap <buffer> O i
	nmap <buffer> R :call chansend(b:terminal_job_id, "\<lt>c-a>\<lt>c-k>. ~/.zshrc\<lt>cr>")<cr>
	nnoremap <buffer> <c-w><c-l> :call Terminal_reset()<cr>
	nnoremap <buffer> D "tyiW:call Terminal_open()<cr>
	nnoremap <buffer> C "tyiW"tpi
	nnoremap <buffer> J :<c-u>call Terminal_modify('J')<cr>
	vnoremap <buffer> J :<c-u>call Terminal_modify('J')<cr>
	nnoremap <buffer> gJ :<c-u>call Terminal_modify('gJ')<cr>
	vnoremap <buffer> gJ :<c-u>call Terminal_modify('gJ')<cr>
	nnoremap <buffer> <silent> yy yy:<c-u>call Terminal_regsub()<cr>
	call Get_git_branch(1)
	AirlineRefresh
endfunction

function! Terminal_open()
	let l:p = expand(@t)
	if isdirectory(l:p)
		call chansend(b:terminal_job_id, "\<c-a>\<c-k>cd " . l:p . "\<cr>")
		startinsert
	elseif filereadable(l:p)
		call chansend(b:terminal_job_id, "\<c-a>\<c-k>v " . l:p . "\<cr>")
	else
		echohl WarningMsg
		echo 'Not a file or directory: ' . l:p
		echohl NONE
	endif
endfunction

function! Terminal_reset()
	setlocal scrollback=1
	call chansend(b:terminal_job_id, "\<c-l>")
	sleep 100m
	setlocal scrollback=-1
	startinsert
endfunction

" reset b:terminal_pwd to avoid race condition
function! Terminal_cd()
	if &buftype == 'terminal' && expand('%') =~# '[\/]zsh$'
		let b:terminal_pwd = getcwd()
		call chansend(b:terminal_job_id, 'NVIM_LISTEN_ADDRESS= cd "' . b:terminal_pwd . "\"\<cr>")
	endif
endfunction

function! Terminal_restore()
	let l:curtab = tabpagenr()
	let l:curwin = winnr()
	tabdo windo call Terminal_cd()
	exec l:curtab . 'tabn'
	exec l:curwin . 'wincmd w'
endfunction

function! Python_autofix()
	if &filetype == 'python'
		let l:pos = getpos('.')
		%!autopep8 %
		write
		call setpos('.', l:pos)
	endif
endfunction

if has('autocmd')
	augroup vimrc
		au!

		au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

		au BufReadPost *bash[-_]* setlocal filetype=sh
		au BufReadPost /tmp/zsh*  setlocal filetype=sh
		au BufReadPost *.cls   setlocal filetype=tex
		au BufReadPost *.o.cmd setlocal filetype=make
		au BufReadPost *.gitconfig setlocal filetype=gitconfig
		au BufNew,BufRead *.bash let b:is_bash = 1

		"au FileType qf setlocal conceallevel=2 "concealcursor=ncv
		"au FileType qf syntax match qfFileName /^[^|]*/ transparent conceal
		"au FileType qf syntax match qfRowsCols /|[0-9]\+ col [0-9]\+|/
		"au FileType qf hi link qfRowsCols Comment

		au FileType sh inoreabbrev <buffer> ssc # shellcheck disable
		au FileType sh inoreabbrev <buffer> sif if; do<CR>then<Up><left><left>
		au FileType sh inoreabbrev <buffer> sfo for; do<CR>done<Up><left>
		au FileType sh inoreabbrev <buffer> swh while; do<CR>done<Up><right>
		au FileType sh inoreabbrev <buffer> snn [ -n "" ]<left><left><left>
		au FileType sh inoreabbrev <buffer> szz [ -z "" ]<left><left><left>
		au FileType sh inoreabbrev <buffer> sff [ -f "" ]<left><left><left>
		au FileType sh inoreabbrev <buffer> sdd [ -d "" ]<left><left><left>

		au Filetype netrw vnoremap <buffer> <silent> t :call NetrwOpenMultiTab(v:count)<CR>
		au Filetype netrw vnoremap <buffer> <silent> <expr> T ":call NetrwOpenMultiTab(" . (( v:count == 0) ? '' : v:count) . ")\<CR>"
		au Filetype netrw nnoremap <buffer> <silent> TT :call NetrwOpenMultiTab()<CR>
		au Filetype netrw setlocal nolist
		au Filetype netrw nnoremap <buffer> e :term<cr>

		au FileType ps1 setlocal ignorecase smartcase

		au FileType rmd,yaml,json,ps1,tf,terraform call MyExpandTab(2)
		au BufReadPost */ccbl/*.sh call MyExpandTab(2)
		au BufReadPost */ccbl/*.java call MyExpandTab(4)


		au FileType sh,python nnoremap <buffer> <space>r :call Run_File('')<cr>
		au FileType sh,python nnoremap <buffer> <space>R :call Run_File('')<left><left>

		au BufWritePost *.vimrc source %

		"if executable('autopep8')
		"        au BufWritePost *.py silent call Python_autofix()
		"endif
	augroup END
endif

try
	" redefinitions for stuff like highlighting must be done after this
	runtime! plugin/sensible.vim
	hi PreProc term=underline ctermfg=12 guifg=#ff80ff
	hi Special term=bold ctermfg=9 guifg=Orange
	hi Pmenu ctermbg=DarkGray guibg=DarkGray
catch
endtry

hi Comment term=standout cterm=bold ctermfg=2 gui=bold guifg=Green

hi DiffText   cterm=none ctermfg=Black ctermbg=Red gui=none guifg=Black guibg=Red
hi DiffChange cterm=none ctermfg=Black ctermbg=LightMagenta gui=none guifg=Black guibg=LightMagenta

"hi clear SpellBad
hi SpellBad ctermfg=009 ctermbg=012

set t_Co=256
set updatetime=250

if !has('nvim')
	set term=xterm-256color
endif

set tags^=./.git/tags;
