#!/bin/bash

# testing='--dry-run'

version="${0##*/} version 0.2"

function update_system {
    sudo xbps-install -Suy
    echo -e 'Update system...\n'

    if [[ $? == 0 ]]; then
        echo -e '\nComplete system update!\n'
    else
        echo -e '\nError! Exiting...\n'
        exit 1
    fi
}

function install_packages {
    update_system
    packages=$(sed -e '/^\s*#/g' -e '/^\s*$/g' packages.txt | tr '\n' ' ')

    echo -e 'Install some packages...\n'
    sudo xbps-install -y $testing ${packages[@]}

    if [[ $? == 0 ]]; then
        echo -e '\nComplete package install!\n'
    else
        echo -e '\nError! Exiting...\n'
        exit 1
    fi
}

function get_desktop {
    desktops='
    1 - xfce4
    2 - bspwm
    '
    echo "$desktops"

    read -p 'Choose a DE or WM: ' desktop

    case $desktop in
        1) sudo xbps-install -y $testing xfce4;;
        2) sudo xbps-install -y $testing bspwm sxhkd;;
    esac

    if [[ $? == 0 ]]; then
        echo -e '\nComplete desktop install!\n'
    else
        echo -e '\nError! Exiting...\n'
        exit 1
    fi
}

function config_system {
    echo 'Configure system...'

    echo -e '\nCopy settings to .config...\n'
    mkdir -p $HOME/.config
    cp -r config/* $HOME/.config/

    echo -e 'Copy hidden files of home...\n'
    for f in home/*; do
        cp -r $f "$HOME/.${f##*/}"
    done

    echo -e 'Source bash_xw...\n'
    echo -e '\n[[ -f ~/.bash_xw ]] && source ~/.bash_xw' >> ~/.bashrc

    echo -e 'Copy bin folder...\n'
    mkdir ~/.local/bin
    cp -r bin/* ~/.local/bin/

    echo -e 'Create user folders...\n'
    xdg-user-dirs-update

    echo -e 'Startx setup...\n'
    echo 'exec dbus-launch --exit-with-session bspwm' >> ~/.xinitrc
}

function post_install_todo {
    cat <<EOF
    POST INSTALLATION TODO
    ---------------------
    -[]get node
    -[]get nerd fonts
    -[]install mscorefonts
    -[]vim setup

EOF
}

function full_install {
    install_packages
    get_desktop
    config_system

    echo -e 'Setup complete...\n'
    read -p 'Press Enter to continue...' continues
    clear
    post_install_todo
}

function setup_help {
    cat <<EOF
    usage: ${0##*/} [flags]

    Options:

    --install          Only install list of packages
    --full-install     Install packages, desktop and config system
    --post-todo        Check Post Installation ToDo
    --version,-v       Show version
    --help,-h          Show this is message

EOF
}

case $@ in
    --install) install_packages && get_desktop;;
    --full-install) full_install;;
    --post-todo) post_install_todo;;
    --version|-v) printf "%s\n" "$version";;
    --help) setup_help;;
    *) setup_help && exit 1;;
esac
