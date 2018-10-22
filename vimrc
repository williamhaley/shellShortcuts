" Syntax highlighting
syntax on

" Show line numbers
set number

" Show horizontal ruler at 80 chars
highlight ColorColumn ctermbg=gray
set colorcolumn=80

" How many columns constitute a tab
set tabstop=4

" How many spaces to use if we shift (indent or dedent) code
set shiftwidth=4

" Use spaces for tab
set expandtab

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

" Whitespace characters
set list
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
