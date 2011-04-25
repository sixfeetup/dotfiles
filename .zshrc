UNAME=$(uname)
source $HOME/.commonfuncs

# Common hashes
#hash -d L=/var/log
#hash -d R=/usr/local/etc/rc.d

# OS X specific settings
if [ $UNAME = "Darwin" ]; then
    
    # set up dir hashes
    #hash -d P=$HOME/sixfeetup/projects
    #hash -d S=$HOME/Sites

fi

# set up common aliases between shells
source $HOME/.commonrc

# global aliases
################
# disable the plonesite part in a buildout run, example: $ bin/buildout -N psef
#alias -g psef="plonesite:enabled=false"
# get the site packages for your python, example: $ cd $(python2.5 site-packages)
#alias -g site_packages='-c "from distutils.sysconfig import get_python_lib; print get_python_lib()"'
# some pipes
alias -g G='| grep'
alias -g L='| less'
alias -g M='| more'
alias -g T='| tail'
alias -g TT='| tail -n20'
if checkPath colordiff; then
    alias -g CD='| colordiff'
else
    alias -g CD='| vim -R -'
fi
# bootstrap with distribute
#alias -g bootstrap='bootstrap.py --distribute'

# turn off the stupid bell
#setopt NO_BEEP
# Changing Directories
setopt AUTO_CD CDABLE_VARS
# automatically save recent directories on the stack
setopt AUTO_PUSHD
setopt PUSHDMINUS
# History
setopt HIST_SAVE_NO_DUPS HIST_VERIFY HIST_IGNORE_ALL_DUPS EXTENDED_HISTORY
# globbing
#setopt GLOB_DOTS

# set up the history-complete-older and newer
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# vi command line editor
########################
# TODO: Un-comment the following line to have vi style keybindings
#bindkey -v
# use home and end to go to end and beginning of the line
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
bindkey -M viins '^[[H' vi-beginning-of-line
bindkey -M viins '^[[F' vi-end-of-line
# use ctrl+a and ctrl+e like emacs mode
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
# use delete as forward delete
bindkey -M viins '\e[3~' vi-delete-char
# line buffer
bindkey -M viins '^B' push-line-or-edit
# change the shortcut for expand alias
bindkey -M viins '^X' _expand_alias
# Search backwards with a pattern
bindkey -M vicmd '^R' history-incremental-pattern-search-backward
bindkey -M vicmd '^F' history-incremental-pattern-search-forward
# set up for insert mode too
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
# complete previous occurences of the command up till now on the command line
bindkey -M viins "^[OA" up-line-or-search
bindkey -M viins "^[[A" up-line-or-search
bindkey -M viins "^N" up-line-or-search
bindkey -M viins "^[OB" down-line-or-search
bindkey -M viins "^[[B" down-line-or-search
bindkey -M viins "^P" down-line-or-search

# History settings
##################
HISTSIZE=3000
SAVEHIST=3000
HISTFILE=~/.zsh_history
export HISTFILE HISTSIZE SAVEHIST

# Completions
#############
#autoload -U compinit
#compinit -C
# case-insensitive (all),partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# uncomment this to show when you aren't the current user
#ME="clayton"

# use some crazy ass shell prompt
# thanks to for the basis: http://aperiodic.net/phil/prompt/
#source $HOME/.zshprompt

# use a simpler 3 line prompt
source $HOME/.zshprompt_simple

# load up per environment extras
source ~/.zshextras
