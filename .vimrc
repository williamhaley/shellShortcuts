syntax on
:set number
:set expandtab
:set tabstop=2
:set shiftwidth=2

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
