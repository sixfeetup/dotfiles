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
"    <leader>f       -- shows the current file in the NERDTree. This
"                       is the TextMate equivalent of ctrl+cmd+r
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
" I have set up some custom commands that might be of interest
"
"    MarkdownToHTML  -- Converts the current buffer into HTML and
"                       places it in a scratch buffer.
"    MarkdownToHTMLCopy -- Same as previous, but copies to clipboard
"    Shell           -- Runs a shell command and places it in the
"                       scratch buffer
"    TidyXML         -- Runs tidy in XML mode on the current buffer
"    TabStyle        -- Set the tab style and number, :TabStyle space 4
"    TerminalHere    -- Opens the terminal to the directory of the
"                       current buffer
"
" -----------------------------------------------------------------

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" FreeBSD security advisory for this one...
set nomodeline

" set the default encoding
set enc=utf-8

" This setting prevents vim from emulating the original vi's
" bugs and limitations.
set nocompatible

" Enhanced command menu ctrl + d to expand directories
set wildmenu
" list completions, then cycle through them
set wildmode=list:longest,full
set wildignore+=*.pyc,*.pyo,CVS,.svn,.git,*.mo,.DS_Store,*.pt.cache,*.Python,*.o,*.lo,*.la,*~,.AppleDouble

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

" highlight all python syntax
let python_highlight_all=1

" gui and terminal compatible color scheme
set t_Co=256

" set global variables that will define the colorscheme
let g:light_theme='mac_classic'
let g:dark_theme='molokai'

" Use the "original" molokai theme colors instead of "dark"
let g:molokai_original=1

" Command to call the ColorSwitch funciton
command! -nargs=? -complete=customlist,s:completeColorSchemes ColorSwitcher :call s:colorSwitch(<q-args>)

" A function to toggle between light and dark colors
function! s:colorSwitch(...)
    " function to switch colorscheme
    function! ChangeMe(theme)
        execute('colorscheme '.a:theme)
        try
            execute('colorscheme '.a:theme.'_custom')
        catch /E185:/
            " There was no '_custom' scheme...
        endtry
    endfunction

    " Change to the specified theme
    if eval('a:1') != ""
        " check to see if we are passing in an existing var
        if exists(a:1)
            call ChangeMe(eval(a:1))
        else
            call ChangeMe(a:1)
        endif
        return
    endif

    " Toggle between a light and dark vim colorscheme
    if &background == 'dark'
        call ChangeMe(g:light_theme)
    elseif &background == 'light'
        call ChangeMe(g:dark_theme)
    endif
endfunction

" completion function for colorscheme names
function! s:completeColorSchemes(A,L,P)
    let colorscheme_names = []
    for i in split(globpath(&runtimepath, "colors/*.vim"), "\n")
        let colorscheme_name = fnamemodify(i, ":t:r")
        if stridx(colorscheme_name, "_custom") < 0
            call add(colorscheme_names, colorscheme_name)
        endif
    endfor
    return filter(colorscheme_names, 'v:val =~ "^' . a:A . '"')
endfunction

" set the colorscheme
ColorSwitcher g:dark_theme

" switch between light and dark colors
map <silent> <leader>c :ColorSwitcher<CR>

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

" Allow command line editing like emacs
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" turn off smart indentation when pasting
set pastetoggle=<F2>

" command to switch tab styles
command! -nargs=+ TabStyle :call s:TabChanger(<f-args>)

" function to switch between tabs and spaces
" initial idea taken from:
" http://github.com/twerth/dotfiles/blob/master/etc/vim/vimrc
function! s:TabChanger(...)
    let l:tab_type = a:1
    if !exists('a:2')
        let l:tab_length = 4
    else
        let l:tab_length = a:2
    endif
    exec 'set softtabstop=' . l:tab_length
    exec 'set shiftwidth=' . l:tab_length
    exec 'set tabstop=' . l:tab_length
    if l:tab_type == "space"
        set expandtab
    elseif l:tab_type =="tab"
        set noexpandtab
    endif
endfunction

TabStyle space 4

" function to run shell commands and create a scratch buffer (modified
" slightly so that it doesn't show the command and it's interpretation)
" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
" Example, show output of ls in a scratch buffer:
"
" :Shell ls -al
"
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = '"'.fnameescape(expand(part)).'"'
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1,substitute(getline(1),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" A function to strip trailing whitespace and clean up afterwards so
" that the search history remains intact and cursor does not move.
" Taken from: http://vimcasts.org/episodes/tidying-whitespace
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

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

" allow for switching buffers when a file has changes
set hidden

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

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
nnoremap <silent> <leader>f :NERDTreeFind<CR>
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
    \'\.AppleDouble$',
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
let g:fuzzy_ignore = "*.png;*.PNG;*.pyc;*.pyo;*.JPG;*.jpg;*.GIF;*.gif;.svn/**;.git/**;*.mo;.DS_Store;.AppleDouble"

" shortcut for ack search
map <leader>a :Ack<Space>

" buffer explorer ctrl + tabbing and single click
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapCTabSwitchBufs = 1

" Delete buffers when i'm done with them in VCSCommand
let VCSCommandDeleteOnHide = 1

" automatically use the wiki text for trac.sixfeetup.com when
" using it's all text
au BufNewFile,BufRead trac.sixfeetup.com.*.txt set syntax=wiki

" run markdown on the current file and place the html in a scratch buffer
command! -nargs=0 MarkdownToHTML  call s:RunShellCommand('Markdown.pl %')
" replace the current buffer with the html version of the markdown
command! -nargs=0 MarkdownToHTMLReplace  %!Markdown.pl "%"
" copy the html version of the markdown to the clipboard (os x)
command! -nargs=0 MarkdownToHTMLCopy  !Markdown.pl "%" | pbcopy
" use pandoc to convert from html into markdown
command! -nargs=0 MarkdownFromHTML  %!pandoc -f html -t markdown "%"

" xml tidy
command! -complete=file -nargs=* TidyXML %!tidy -xml -i -q -w 0
map <leader>T :TidyXML<CR>

" open up the current file's folder in the terminal
" TODO: Make this work cross platform/terminal program (a plugin perhaps?)
command TerminalHere silent !roxterm --tab --directory=%:p:h

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
"set listchars=tab:▸\ ,eol:¬
" show invisible characters by default
"set list
" toggle invisible characters
noremap <silent> <leader>i :set list!<CR>

" make the taglist show on the right side
let Tlist_Use_Right_Window = 1
" only show the current buffer, fold the rest
let Tlist_File_Fold_Auto_Close = 1
" Show the zcml names in the current taglist
let tlist_xml_settings = 'zcml;n:name'
" Show buildout section names in the taglist
let tlist_cfg_settings = 'ini;s:section'
" mapping for taglist
nnoremap tt :TlistToggle<CR>

" -----------------------------------------------------------------
" GUI settings
" -----------------------------------------------------------------
if has("gui_running")

    " turn off the cursor blinking (who thinks that is a good idea?)
    "set guicursor+=a:blinkon0

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

