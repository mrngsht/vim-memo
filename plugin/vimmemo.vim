function! MemoOpenWithoutFocus(size) 
  let s:now_window_id = win_getid()
  call MemoOpen(a:size)
  call win_gotoid(s:now_window_id)
endfunction 

function! MemoOpen(size) 
  if !exists('g:vim_memo_window_id')  
    if !exists('g:vim_memo_file_path')
      let g:vim_memo_file_path = '~/.cache/memo/memo'
    endif
    silent! execute 'topleft ' . a:size . ' split'
    silent! execute 'e ' . g.vim_memo_file_path
    silent! execute 'setlocal bufhidden=hide'
    silent! execute 'setlocal nobuflisted'
    let g:vim_memo_window_id = win_getid()
    let g:vim_memo_buf_nr= bufnr('%')
  else 
    let s:win_num = win_id2win(g:vim_memo_window_id)
    if s:win_num != 0
      if win_getid() != g:vim_memo_window_id 
        call win_gotoid(g:vim_memo_window_id)
        silent! execute 'resize ' . a:size 
      elseif bufnr('%') != g:vim_memo_buf_nr
        silent! execute 'topleft ' . a:size . ' split +b' . g:vim_memo_buf_nr
        let g:vim_memo_window_id = win_getid()
        let g:vim_memo_buf_nr= bufnr('%')
      else
        call win_gotoid(win_getid(winnr() + 1))
      endif
    else
      silent! execute 'topleft ' . a:size . ' split +b' . g:vim_memo_buf_nr
      let g:vim_memo_window_id = win_getid()
      let g:vim_memo_buf_nr= bufnr('%')
    endif
  endif
endfunction

function! MemoClose() 
  if exists('g:vim_memo_window_id')  
    let s:win_num = win_id2win(g:vim_memo_window_id)
    if s:win_num != 0
      silent! execute s:win_num . 'hide'
      if win_id2win(g:vim_memo_window_id) != 0
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
