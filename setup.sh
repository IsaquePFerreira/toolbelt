#!/bin/bash

clear

echo -e 'Update system...\n'
sudo xbps-install -Suy

if [[ $? == 0 ]]; then
    echo -e '\nComplete system update!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

package_list=(
    intel-ucode
    xorg-minimal
    xf86-input-synaptics
    xf86-video-intel
    linux-firmware
    libX11-devel
    libXft-devel
    libXinerama-devel
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
    font-awesome6
    terminus-font
    font-hack-ttf
    picom
    gnome-themes-extra
    greybird-themes
    papirus-icon-theme
    papirus-folders
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

echo -e 'Install some packages...\n'
sudo xbps-install -Sy --dry-run ${package_list[@]}

if [[ $? == 0 ]]; then
    echo -e '\nComplete package install!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

echo

echo -e 'Copy settings to .config...\n'
mkdir -p $HOME/.config
cp -r config/* $HOME/.config/

echo -e 'Copy hidden files of home...\n'
for f in home/*; do
    cp -r $f "$HOME/.${f##*/}"
done

