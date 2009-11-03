" -----------------------------------------------------------------
"
" This is your vim configuration file. There are some shortcuts set
" up for you by default.  Here are the highlights:
"
" The mapleader has been switched from '\' to ',' anytime you see
" <leader> that is what this refers to.
"
"    <leader>t       -- opens the TextMate fuzzy finder
"    tt              -- opens up the taglist 
"    <leader>h       -- toggles the highlight search
"    <leader>n       -- toggles the line numbers
"    <leader>a       -- starts an ack search in the CWD
"    <leader>i       -- toggles invisible characters
"    <leader>x       -- toggles NERDTree drawer
"    <leader>b       -- shortcut for getting to NERDTree bookmarks
"    <leader><Enter> -- opens a line at the current column (this is
"                       the reverse of J)
"    jj              -- alternative to <ESC>
"    ;               -- alternative to :
"    ctrl + tab      -- cycle through buffers/tabs
"    <Enter>         -- open a new line (non-insert)
"    <S-Enter>       -- open a new line above (non-insert)
"
" -----------------------------------------------------------------
" FreeBSD security advisory for this one...
set nomodeline

" This setting prevents vim from emulating the original vi's
" bugs and limitations.
set nocompatible

" Enhanced command menu ctrl + d to expand directories
set wildmenu
set wildignore+=*.pyc,*.pyo,CVS,.svn,.git,*.mo,.DS_Store,*.pt.cache,*.Python,*.o,*.lo,*.la,*~

" set the mapleader key
let mapleader = ","
let g:mapleader = ","

" set up jj as mode switch
map! jj <ESC>

" hide the backup and swap files
set backupdir=~/.backup/vim,.,/tmp
set directory=~/.backup/vim/swap,.,/tmp
set backupskip=/tmp/*,/private/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*

" turn on syntax highlighting
syntax on

" gui and terminal compatible color scheme
set t_Co=256

" a nicer default colorscheme for a light
" background
colorscheme simplewhite

" Uncomment the following for a dark background terminal
" also uncomment the colorschemes for a nice theme
"set background=dark
" a 256 color enhanced version of ir_black
"colorscheme tir_black
" my mods to the theme
"colorscheme tir_black_custom

" highlight the cursor line
set cursorline

" turn on line numbers, aww yeah
set number
" shortcut to turn off line numbers
map <silent> <leader>n :set number!<CR>

" The first setting tells vim to use "autoindent" (that is, use the current
" line's indent level to set the indent level of new lines). The second makes
" vim attempt to intelligently guess the indent level of any new line based on
" the previous line.
"set autoindent
"set smartindent

" function to switch between tabs and spaces
" taken from: http://github.com/twerth/dotfiles/blob/master/etc/vim/vimrc
function! Tabstyle_tabs()
  " Using 4 column tabs
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set noexpandtab
endfunction

function! Tabstyle_spaces()
  " Use 2 spaces
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set expandtab
endfunction

call Tabstyle_spaces()

" -----------------------------------------------------------------
" Searching
" -----------------------------------------------------------------
" find as you type
set incsearch
" highlight the terms
"set hlsearch
" make searches case-insensitive
set ignorecase
" unless they contain upper-case letters
set smartcase
" a toggle for search highlight
map <silent> <leader>h :set hlsearch!<CR>

" have fifty lines of command-line (etc) history:
set history=1000

" This setting ensures that each window contains a statusline that displays the
" current cursor position.
set ruler

" Display an incomplete command in the lower right corner of the Vim window
set showcmd

" Set a margin of lines when scrolling
set so=4

" have the mouse enabled all the time:
set mouse=a

" By default, vim doesn't let the cursor stray beyond the defined text. This 
" setting allows the cursor to freely roam anywhere it likes in command mode.
" It feels weird at first but is quite useful.
"set virtualedit=all

" tell the bell to go beep itself!
set visualbell t_vb=

" --------------------------------------------
" Settings trying to make vim like TextMate :)
" --------------------------------------------

" turn on filetype checking for plugins like pyflakes
filetype on            " enables filetype detection
filetype plugin indent on     " enables filetype specific plugins

" NERDTree settings
" -----------------------------------------------------------------
" set project folder to x
map <leader>x :NERDTreeToggle<CR>
map <leader>b :NERDTreeFromBookmark 
" files/dirs to ignore in NERDTree (mostly the same as my svn ignores)
let NERDTreeIgnore=[
    \'\~$',
    \'\.pt.cache$',
    \'\.Python$',
    \'\.svn$',
    \'\.git*$',
    \'\.pyc$',
    \'\.pyo$',
    \'\.mo$',
    \'\.o$',
    \'\.lo$',
    \'\.la$',
    \'\..*.rej$',
    \'\.rej$',
    \'\.DS_Store$']
" set the sort order to alphabetical
let NERDTreeSortOrder=[]
" when the root is changed, change Vim's working dir
let NERDTreeChDirMode=2
" -----------------------------------------------------------------

" Fuzzy finder TextMate plugin
" -----------------------------------------------------------------
" max results, lot o' files in a buildout :)
let g:fuzzy_ceiling=35000
" show full paths
let g:fuzzy_path_display = 'highlighted_path'
" ignored files
let g:fuzzy_ignore = "*.png;*.PNG;*.pyc;*.pyo;*.JPG;*.jpg;*.GIF;*.gif;.svn/**;.git/**;*.mo;.DS_Store"

" shortcut for ack search
map <leader>a :Ack

" buffer explorer ctrl + tabbing and single click
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapCTabSwitchBufs = 1

" automatically use the wiki text for trac.sixfeetup.com when
" using it's all text
au BufNewFile,BufRead trac.sixfeetup.com.*.txt set syntax=wiki

" markdown syntax
augroup mkd
 autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
augroup END
command! -complete=file -nargs=* MarkdownToHTML  call s:RunShellCommand('Markdown.pl %')
command! -complete=file -nargs=* MarkdownToHTMLCopy  !Markdown.pl % | pbcopy

" shell files
au BufNewFile,BufRead .common* set filetype=sh

" Zope and Plone files
" -----------------------------------------------------------------
" xml syntax for zcml files
au BufNewFile,BufRead *.zcml set filetype=xml
" css.dtml as css
au BufNewFile,BufRead *.css.dtml set filetype=css
" js.dtml as javascript
au BufNewFile,BufRead *.js.dtml set filetype=javascript

" fuzzy finder text mate mapping
map <leader>t :FuzzyFinderTextMate<CR>

" Make cursor move by visual lines instead of file lines (when wrapping)
" This makes me feel more at home :)
map <up> gk
map k gk
imap <up> <C-o>gk
map <down> gj
map j gj
imap <down> <C-o>gj
map E ge

" Insert newlines with enter and shift + enter
map <S-Enter> O<ESC>
map <Enter> o<ESC>
" open a new line from the current spot (sort of the opposite of J)
map <leader><Enter> i<CR><ESC>

" map ; to : so you don't have to use shift
map ; :

" set up the invisible characters
" -----------------------------------------------------------------
"set listchars=eol:¬,tab:»\ 
" show invisible characters by default
"set list
" toggle invisible characters
noremap <silent> <leader>i :set list!<CR>

" mapping for taglist
nnoremap tt :TlistToggle<CR>

" -----------------------------------------------------------------
" GUI settings
" -----------------------------------------------------------------
if has("gui_running")

    " Default size of window
    set columns=145
    set lines=45
    
    " automagically open NERDTree in a GUI
    autocmd VimEnter * exe 'NERDTreeToggle' | wincmd l
    " close the NERDTree when opening trac pages
    autocmd VimEnter,BufNewFile,BufRead trac.sixfeetup.com.*.txt exe 'NERDTreeClose'
    autocmd VimEnter,BufNewFile,BufRead trac.sixfeetup.com.*.txt set nonumber

    " OS Specific
    if has("gui_macvim")
        "set fuoptions=maxvert,maxhorz " fullscreen options (MacVim only), resized window when changed to fullscreen
        set guifont=Monaco:h10
        set guioptions-=T " remove toolbar
    endif

endif

