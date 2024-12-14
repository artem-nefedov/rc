function! TagsRegenerateDone(...)
    if a:2 == 0
        echom 'Done re-generating tags'
    else
        echohl WarningMsg
        echom 'ctags exited with code ' . a:2
        echohl NONE
    endif
endfunction

function! TagsRegenerate()
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
    call jobstart('ctags --tag-relative=yes --exclude=.git -R -f .git/tags .', {'on_exit': 'TagsRegenerateDone'})

    if &buftype == 'terminal'
        silent exec 'lcd ' . l:cwd
    endif
endfunction

set tags^=./.git/tags;
nnoremap <leader>T <cmd>call TagsRegenerate()<cr>
