#!/bin/bash

set_keys() {
    echo 'Keyboard setup...'
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo cp -ruv xorg.conf.d/* /etc/X11/xorg.conf.d/
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

    --all,-a       	        Complete config system
    --keys,-k       	    Set keyboard settings
    --configs,-c	        Set ~/.config
    --home,-ho 	            Set home hidden files
    --src,-s                Set scripts folder
    --help,-h          	    Show this is message

EOF
}

set -e

case $@ in
	--all|-a) config_sys;;
	--keys|-k) set_keys;;
	--configs|-c) set_configs;;
	--home|-ho) set_home_hidden_files;;
	--src|-s) set_bin_folder;;
	--help|-h) _help;;
	*) echo 'Invalid parameter!' && _help;;
esac
