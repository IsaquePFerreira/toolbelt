#!/bin/bash

_DOT_DIR="$HOME/.dotfiles"
source $_DOT_DIR/PACKAGES

req_pkgs() {
    echo 'Install some packages...'
    sudo apt install -y ${PACKAGES[@]}
}

set_fonts() {
    echo 'Copy fonts...'
    mkdir -pv $HOME/.local/share/fonts
    cp -ruv $_DOT_DIR/fonts/* $HOME/.local/share/fonts/
    fc-cache -fv
}

set_wallpapers() {
    echo 'Download wallpapers...'
    cd /tmp
    [[ -d wallpapers ]] && rm -rf wallpapers
    git clone https://github.com/IsaquePFerreira/wallpapers
    echo 'Copy wallpapers...'
    mkdir -pv $HOME/Pictures/wallpapers
    cp -ruv wallpapers/* $HOME/Pictures/wallpapers/
}

set_configs() {
    echo 'Set configs...'
    mkdir -pv $HOME/.config
    cp -ruv $_DOT_DIR/config/* $HOME/.config/
}

set_home_hidden_files() {
    echo 'Copy hidden files of home...'
    for f in $_DOT_DIR/home/*; do
        cp -ruv $f "$HOME/.${f##*/}"
    done

    echo 'Source bash_aliases...'
    if grep '~/.bash_aliases' $HOME/.bashrc &> /dev/null; then
        echo 'bash_aliases is already set!'
    else
        echo -e '\n[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases' >> $HOME/.bashrc
    fi
}

set_bin_folder() {
    echo 'Copy bin folder...'
    mkdir -p $HOME/.local/bin
    cp -ruv $_DOT_DIR/bin/* $HOME/.local/bin/
}

config_sys() {
    echo 'Configure system...'
    req_pkgs
    set_fonts
    set_wallpapers
    set_configs
    set_home_hidden_files
    set_bin_folder
    bspc wm -r
    reset && clear && neofetch
}

_help() {
cat << EOF

usage: ${0##*/} [flags]

  Options:

    --all            Complete config system
    --install        Install required packages
    --keyboard       Set keyboard settings
    --config         Set ~/.config
    --home           Set home hidden files
    --bin            Set scripts folder
    --help           Show this is message

EOF
}

set -e

case $@ in
    --all)      config_sys;;
    --install)  req_pkgs;;
    --keyboard) set_keys;;
    --config)   set_configs;;
    --home)     set_home_hidden_files;;
    --bin)      set_bin_folder;;
    --help)     _help;;
    *) echo 'Invalid parameter!' && _help;;
esac
