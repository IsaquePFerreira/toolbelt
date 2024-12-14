#!/bin/bash

set_keys() {
    echo 'Keyboard setup...'
    if grep 'setxkbmap -layout br-abnt2' $HOME/.xinitrc &> /dev/null; then
        echo 'keyboad layout is already set!'
    else
        echo 'setxkbmap -layout br-abnt2' > $HOME/.xinitrc
    fi
}

set_configs() {
    echo 'Create ~/.config folder and copy settings'
	echo 'Copy settings to .config...'
	mkdir -p $HOME/.config
	cp -ruv config/* $HOME/.config/
}

set_home_hidden_files() {
    echo 'Copy hidden files of home...'
    for f in home/*; do
        cp -ruv $f "$HOME/.${f##*/}"
    done

    echo 'Source bash_xw...'
    if grep '~/.bash_xw' $HOME/.bashrc &> /dev/null; then
        echo 'bash_xw is already set!'
    else
        echo -e '\n[[ -f ~/.bash_xw ]] && source ~/.bash_xw' >> $HOME/.bashrc
    fi
}

set_bin_folder() {
    echo 'Copy bin folder...'
    mkdir -p $HOME/bin
    cp -ruv bin/* $HOME/bin/
}

config_sys() {
    echo 'Configure system...'
    set_keys
    set_configs
    set_home_hidden_files
    set_bin_folder
}

_help() {
cat << EOF

usage: ${0##*/} [flags]

  Options:

    --all       	        Complete config system
    --keyboard       	    Set keyboard settings
    --config	            Set ~/.config
    --home 	                Set home hidden files
    --bin                   Set scripts folder
    --help          	    Show this is message

EOF
}

set -e

case $@ in
	--all) config_sys;;
	--keys) set_keys;;
	--config) set_configs;;
	--home) set_home_hidden_files;;
	--bin) set_bin_folder;;
	--help) _help;;
	*) echo 'Invalid parameter!' && _help;;
esac
