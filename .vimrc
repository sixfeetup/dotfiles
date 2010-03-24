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
"    <leader>T       -- Run tidy xml on the current file
"    <leader>i       -- toggles invisible characters
"    <leader>x       -- toggles NERDTree drawer
"    <leader>b       -- shortcut for getting to NERDTree bookmarks
"    <leader><Enter> -- opens a line at the current column (this is
"                       the reverse of J)
"    <leader>c       -- Switch between light and dark colors
"    jj              -- alternative to <ESC>
"    ;               -- alternative to :
"    ctrl + tab      -- cycle through buffers/tabs
"    <Enter>         -- open a new line (non-insert)
"    <S-Enter>       -- open a new line above (non-insert)
"    <leader>s       -- Toggle spell checking
"    <F2>            -- Toggle smart indent on paste
"    CTRL-=          -- Make the current window taller
"    CTRL-- (CTRL-DASH) -- Make the current window shorter
"
" -----------------------------------------------------------------

" FreeBSD security advisory for this one...
set nomodeline

" set the default encoding
set enc=utf-8

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

" turn on spell checking
"set spell spelllang=en_us
map <silent> <leader>s :set spell!<CR>

" -----------------------------------------------------------------
" Colors and Syntax
" -----------------------------------------------------------------
" turn on syntax highlighting
syntax on

" gui and terminal compatible color scheme
set t_Co=256

" a nicer default colorscheme for a light
" background
colorscheme simplewhite
colorscheme simplewhite_custom

" Uncomment the following for a dark background terminal
" also uncomment the colorschemes for a nice theme
"set background=dark
" a 256 color enhanced version of ir_black
"colorscheme tir_black
" my mods to the theme
"colorscheme tir_black_custom

" A function to toggle between light and dark colors
function! ColorSwitch()
    " check for the theme, and switch to the other one.
    " I had this working with &background == 'dark/light' but something
    " stopped working for me :()
    if g:colors_name == 'tir_black'
        colorscheme simplewhite
        colorscheme simplewhite_custom
    elseif g:colors_name == 'simplewhite'
        colorscheme tir_black
        colorscheme tir_black_custom
        return
    endif
endfunction

" switch between light and dark colors
map <silent> <leader>c :call ColorSwitch()<CR>

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

" turn off smart indentation when pasting
set pastetoggle=<F2>

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

" This setting will cause the cursor to very briefly jump to a 
" brace/parenthese/bracket's "match" whenever you type a closing or 
" opening brace/parenthese/bracket.
set showmatch

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

" Display an incomplete command in the lower right corner of the Vim window
set showcmd

" Set a margin of lines when scrolling
set so=4

" This setting ensures that each window contains a statusline that displays the
" current cursor position.
set ruler

" set a custom status line similar to that of ":set ruler"
"set statusline=\ \ \ \ \ line:%l\ column:%c\ \ \ %M%Y%r%=%-14.(%t%)\ %p%%
" show the statusline in all windows
set laststatus=2

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
map <leader>b :NERDTreeFromBookmark<Space>
nnoremap <silent> <leader>f :call FindInNERDTree()<CR>
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
    \'\.\~lock.*#$',
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
map <leader>a :Ack<Space>

" buffer explorer ctrl + tabbing and single click
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapCTabSwitchBufs = 1

" automatically use the wiki text for trac.sixfeetup.com when
" using it's all text
au BufNewFile,BufRead trac.sixfeetup.com.*.txt set syntax=wiki

" run markdown on the current file
command! -complete=file -nargs=* MarkdownToHTML  call s:RunShellCommand('Markdown.pl %')
command! -complete=file -nargs=* MarkdownToHTMLCopy  !Markdown.pl % | pbcopy

" xml tidy
command! -complete=file -nargs=* TidyXML %!tidy -xml -i -q -w 0
map <leader>T :TidyXML<CR>

" shell files
au BufNewFile,BufRead .common* set filetype=sh

" Zope and Plone files
" -----------------------------------------------------------------
" xml syntax for zcml files
au BufNewFile,BufRead *.zcml set filetype=xml
" css.dtml as css
au BufNewFile,BufRead *.css.dtml set filetype=css
" kss files as css
au BufNewFile,BufRead *.kss set filetype=css syntax=kss
" js.dtml as javascript
au BufNewFile,BufRead *.js.dtml set filetype=javascript
" any txt file in a `tests` directory is a doctest
au BufNewFile,BufRead /*/tests/*.txt set filetype=doctest

" fuzzy finder text mate mapping
map <silent> <leader>t :FuzzyFinderTextMate<CR>

" Make cursor move by visual lines instead of file lines (when wrapping)
" This makes me feel more at home :)
map <up> gk
map k gk
imap <up> <C-o>gk
map <down> gj
map j gj
imap <down> <C-o>gj
map E ge

" window resizing
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif

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

" make the taglist show on the right side
let Tlist_Use_Right_Window = 1
" only show the current buffer, fold the rest
let Tlist_File_Fold_Auto_Close = 1
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
    " close the NERDTree when opening it's all text and vimperator
    " editors
    autocmd VimEnter,BufNewFile,BufRead /*/itsalltext/* exe 'NERDTreeClose'
    autocmd VimEnter,BufNewFile,BufRead /*/itsalltext/* set nospell

    " OS Specific
    if has("gui_macvim")
        "set fuoptions=maxvert,maxhorz " fullscreen options (MacVim only), resized window when changed to fullscreen
        set guifont=Monaco:h10
        set guioptions-=T " remove toolbar
    endif

endif

