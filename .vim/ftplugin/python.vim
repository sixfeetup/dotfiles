" Custom settings for Python files
" -----------------------------------------------------------------

" make sure tabs are set up properly in python
setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 smartindent autoindent

" Highlight lines past column 80 in python files
au BufWinEnter,BufEnter * call clearmatches()
au BufWinEnter,BufEnter *.{v,c,}py let w:m2=matchadd('ErrorMsg', '\%>79v.\+', -1)

" remove trailing whitespace on save
autocmd BufWritePre *.{v,c,}py :call StripTrailingWhitespaces()

" run pep8 on the current file
map <leader>p :Shell pep8 --repeat --show-source %<CR>
" run pep8 on the src dir
map <leader>o :Shell pep8 --repeat --show-source --exclude=paste src<CR>
