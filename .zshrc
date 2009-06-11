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
# disable the plonesite part in a buildout run
#alias -g psef="plonesite:enabled=false"
# get the site packages for your python
#alias -g site_packages='-c "from distutils.sysconfig import get_python_lib; print get_python_lib()"'

# turn off the stupid bell
#setopt NO_BEEP
# Changing Directories
setopt AUTO_CD CDABLE_VARS
# History
setopt HIST_SAVE_NO_DUPS HIST_VERIFY HIST_IGNORE_ALL_DUPS EXTENDED_HISTORY
# globbing
#setopt GLOB_DOTS

# vi command line editor
########################
#bindkey -v
# use home and end to go to end and beginning of the line
#bindkey -M viins '^[[H' vi-beginning-of-line
#bindkey -M viins '^[[F' vi-end-of-line
# use ctrl+a and ctrl+e like emacs mode
#bindkey -M viins '^A' vi-beginning-of-line
#bindkey -M viins '^E' vi-end-of-line
# use delete as forward delete
#bindkey -M viins '\e[3~' vi-delete-char
# line buffer
#bindkey -M viins '^B' push-line-or-edit

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
