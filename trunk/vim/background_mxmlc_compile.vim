function! BackgroundSetFirstError(first)
    lgetexpr a:first
endfunction

function! BackgroundAddErrors(errors)
    laddexpr a:errors
endfunction

function! BackgroundFinish(msg, errors)
    laddexpr a:errors
    echomsg a:msg
    redraw
endfunction
