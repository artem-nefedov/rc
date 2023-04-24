" reset b:terminal_pwd to avoid race condition
function! TerminalCD()
  if &buftype == 'terminal' && expand('%') =~# '[\/]zsh$'
    let b:terminal_pwd = getcwd()
    call chansend(b:terminal_job_id, 'NVIM= cd "' . b:terminal_pwd . "\"\<cr>")
  endif
endfunction

function! TerminalReset()
  setlocal scrollback=1
  call chansend(b:terminal_job_id, "\<c-l>")
  sleep 100m
  setlocal scrollback=-1
  startinsert
endfunction

function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout!' buf
  endfor
endfunction

function! GoBack(write)
  if a:write == 1 && &readonly != 1
    write
  endif
  if &bufhidden == 'delete' || &bufhidden == 'wipe'
    q!
  elseif b:nvr_jump == -1
    echom 'Nowhere to jump'
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
    nnoremap <buffer> ZQ :call GoBack(0)<cr>
    nnoremap <buffer> ZZ :call GoBack(1)<cr>
  catch
  endtry
endfunction

function! GetGitBranch(force)
  if ( exists('b:allow_git_refresh') && b:allow_git_refresh ) || a:force
    let b:last_read_git_branch = systemlist('git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo --')[0]
    return b:last_read_git_branch
  else
    return exists('b:last_read_git_branch') ? b:last_read_git_branch : '--'
  endif
endfunction
