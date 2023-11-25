#!/usr/bin/env bash

xws_title='--------------------
  XWScr Work Setup
--------------------'

list_packages=(
    intel-ucode
    xorg-minimal
    xf86-input-synaptics
    xf86-video-intel
    linux-firmware
    setxkbmap
    xrandr
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-user-dirs
    xdg-user-dirs-gtk
    xdg-utils
    dbus
    dbus-x11
    polkit
    polkit-elogind
    elogind
    xfce-polkit
    noto-fonts-ttf
    terminus-font
    font-hack-ttf
    picom
    gnome-themes-extra
    graybird-themes
    papirus-icon-theme
    papirus-folder
    base-devel
    sakura
    ufw
    keepassxc
    firefox
    nemo
    gvfs
    gvfs-mtp
    file-roller
    nemo-fileroller
    atril
    curl
    wget
    lynx
    w3m
    w3m-img
    ranger
    git
    pulseaudio
    pavucontrol
    pamixer
    dunst
    bash-completion
    htop
    neofetch
    neovim
    p7zip
    unzip
    zip
    unrar
    gimp
    sxiv
    mpv
    mupdf
    ncdu
    fzf
)

_exit() {
    echo -e '\nSaindo...\n'
    exit $1
}

confirm() {
    read -p "$1" resp
    [[ ! ${resp,,} == 's' ]] && _exit
}

_continue() {
    read -p 'Tecle Enter para continuar...' continues
}

clear
echo "$xws_title"
echo -e '\nIniciando pós-instalação...\n'
echo -e 'Atualizando cache do repositório...\n'
sudo xbps-install -S
if [[ $? == 0 ]]; then
    echo -e '\nRepositório Atualizado com sucesso!'
else
    echo -e '\nAlgo de estranho aconteceu...\n'
    _exit 1
fi
echo -e '\nInstalação de pacotes...\n'
echo -e 'Pacotes a serem instalados:'
printf '%s\n' ${list_packages[@]}
echo
confirm 'Iniciar instalação dos pacotes?[s/N] '
sudo xbps-install -n ${list_packages[@]}
if [[ $? == 0 ]]; then
    echo -e '\nPacotes instalados com sucesso!\n'
else
    echo -e '\nAlgo de estranho aconteceu...\n'
    _exit 1
fi
clear
