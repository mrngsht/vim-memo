function! MemoOpenWithoutFocus(size) 
  let s:now_window_id = win_getid()
  call MemoOpen(a:size)
  call win_gotoid(s:now_window_id)
endfunction 

function! MemoOpen(size) 
  if !ExistsWindow(tabpagenr())
    if !exists('g:vim_memo_file_path')
      let g:vim_memo_file_path = '~/.cache/memo/memo'
    endif
    silent! execute 'topleft ' . a:size . ' split'
    silent! execute 'e ' . g:vim_memo_file_path
    silent! execute 'setlocal bufhidden=hide'
    silent! execute 'setlocal nobuflisted'
    call SaveWindow(tabpagenr(), win_getid())
    call SaveBuf(tabpagenr(), bufnr('%'))
  else 
    let s:win_num = win_id2win(GetWindow(tabpagenr()))
    if s:win_num != 0
      if win_getid() != GetWindow(tabpagenr())
        call win_gotoid(GetWindow(tabpagenr()))
        silent! execute 'resize ' . a:size 
      elseif ExistsBuf(tabpagenr()) && GetBuf(tabpagenr()) != bufnr('%')
        silent! execute 'topleft ' . a:size . ' split +b' . GetBuf(tabpagenr())
        call SaveWindow(tabpagenr(), win_getid())
        call SaveBuf(tabpagenr(), bufnr('%'))
      else
        call win_gotoid(win_getid(winnr() + 1))
      endif
    else
      silent! execute 'topleft ' . a:size . ' split +b' . GetBuf(tabpagenr())
      call SaveWindow(tabpagenr(), win_getid())
      call SaveBuf(tabpagenr(), bufnr('%'))
    endif
  endif
endfunction

function! MemoClose() 
  if ExistsWindow(tabpagenr())
    let s:win_num = win_id2win(GetWindow(tabpagenr()))
    if s:win_num != 0
      silent! execute s:win_num . 'hide'
      if win_id2win(GetWindow(tabpagenr())) != 0
        return 0
      endif
      return 1
    endif
  endif
  return 0
endfunction 

function! MemoToggle(size) 
  if !MemoClose()
    call MemoOpen(a:size)
  endif
endfunction

function! MemoToggleWithoutFocus(size) 
  if !MemoClose()
    call MemoOpenWithoutFocus(a:size)
  endif
endfunction

function! SaveBuf(tabnr, bufnr) abort
  if !exists('g:term_stack_buf_nr')
    let g:term_stack_buf_nr = {}
  endif
  let g:term_stack_buf_nr[printf("%d", a:tabnr)]=a:bufnr
endfunction

function! ExistsBuf(tabnr) abort
  if !exists('g:term_stack_buf_nr')
    return 0
  endif
  return has_key(g:term_stack_buf_nr, printf("%d", a:tabnr))
endfunction

function! GetBuf(tabnr) abort
  return g:term_stack_buf_nr[printf("%d", a:tabnr)]
endfunction

function! SaveWindow(tabnr, winid) abort
  if !exists('g:term_stack_window_id')
    let g:term_stack_window_id = {}
  endif
  let g:term_stack_window_id[printf("%d", a:tabnr)]=a:winid
endfunction

function! ExistsWindow(tabnr) abort
  if !exists('g:term_stack_window_id')
    return 0
  endif
  return has_key(g:term_stack_window_id, printf("%d", a:tabnr))
endfunction

function! GetWindow(tabnr) abort
  return g:term_stack_window_id[printf("%d", a:tabnr)]
endfunction

