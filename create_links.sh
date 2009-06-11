#!/usr/bin/env bash

########################################
# This is the list of conf files that we
# want to automagically link after
# checking out to the remote machine
########################################

remove="$1"

dotfiles=(
    .ackrc
    .bash_profile
    .bashrc
    .commonrc
    .commonenv
    .commonprofile
    .commonfuncs
    .inputrc
    .pystartup
    .screenrc
    .vimrc
    .zprofile
    .zshenv
    .zshprompt
    .zshprompt_simple
    .zshrc
    config
)

for dotfile in "${dotfiles[@]}"
    do
        the_dotfile=$HOME/.dotfiles/$dotfile
        # subversion config is an exception
        if [ $dotfile = 'config' ]; then
            to_create=$HOME/.subversion/$dotfile
        else
            to_create=$HOME/$dotfile
        fi
        if [ $remove = "unlink" ]; then
            if [ -e $to_create ]; then
                rm $to_create
                echo "Unlinked $to_create"
            fi
        else
            # symlink the conf file
            if [ ! -e $to_create ]; then
                echo "linking $dotfile"
                ln -s $the_dotfile $to_create
            fi
            # warn the user that an existing file is in the way
            if [ ! -h $to_create -a -e $to_create ]; then
                echo "Remove $to_create so that it can be linked"
            fi
        fi
    done

# touch extra files needed by the confs.
touch_me=(
    .zsh_history
    .bash_history
    .zshextras
    .zshenv_extras
    .bash_extras
)
for to_touch in "${touch_me[@]}"
    do
        if [ ! -e $to_touch ]; then
            echo "touching $to_touch"
        fi
        touch $HOME/$to_touch
    done

# create a $HOME/bin if it does not exist
HOME_BIN="$HOME/bin"
if [[ ! -d "$HOME_BIN" ]] && [[ ! -a "$HOME_BIN" ]]; then
    mkdir "$HOME/bin" && echo 'created a $HOME/bin directory'
elif [[ ! -d "$HOME_BIN" ]] && [[ -a "$HOME_BIN" ]]; then
    echo "something in the way of $HOME_BIN being created"
fi
