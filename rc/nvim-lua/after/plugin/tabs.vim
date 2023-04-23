function! TabMove(sign)
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

  " silent! call repeat#set("\<c-x>" . l:key, v:count1)
endfunction
