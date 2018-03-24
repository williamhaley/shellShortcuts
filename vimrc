" Syntax highlighting
syntax on

" Show line numbers
set number

" How many columns constitute a tab
set tabstop=4

" Change line number highlight
hi LineNr ctermfg=DarkMagenta

" Only autocomplete for .go files
" https://github.com/Valloric/YouCompleteMe#the-gycm_filetype_whitelist-option
let g:ycm_filetype_whitelist = { 'go': 1 }

" Spellcheck
set spelllang=en
set spell
hi clear SpellBad
hi SpellBad cterm=underline,bold

