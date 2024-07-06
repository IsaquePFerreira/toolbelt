#!/bin/bash

# Uncomment this line to testing mode in package manager
# testing='--dry-run'

# Package list
packages=(
linux-firmware
xorg
libXft-devel
libX11-devel
libXinerama-devel
libXrender-devel
dbus
polkit
elogind
# xfce4
bspwm
sxhkd
# rofi
dmenu
# polybar
xfce4-terminal
xfce4-panel
xfce4-whiskermenu-plugin
octoxbps
xfce4-pulseaudio-plugin
neovim
xdg-user-dirs
xdg-utils
xdg-desktop-portal
terminus-font
font-hack-ttf
fonts-roboto-ttf
# font-awesome6
picom
lxappearance
plata-theme
papirus-icon-theme
papirus-folders
breeze-cursors
firefox
firefox-i18n-pt-BR
thunderbird
thunderbird-i18n-pt-BR
keepassxc
Thunar
thunar-archive-plugin
thunar-volman
gvfs
gvfs-mtp
file-roller
atril
flameshot
nitrogen
mpv
gimp
curl
wget
w3m
w3m-img
ranger
htop
ufetch
bash-completion
p7zip
unzip
zip
unrar
nsxiv
mupdf
ncdu
fzf
ufw
gufw
pulseaudio
pavucontrol
pamixer
dunst
xfce-polkit
git
base-devel
lua
libreoffice
libreoffice-i18n-pt-BR
)

# Update system
echo -e 'Update system...\n'
sudo xbps-install -Suy

# If exit status equals success 0 OK! If not, exit with error status 1 
if [[ $? == 0 ]]; then
    echo -e '\nComplete system update!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

# Installing some packages
echo -e 'Install some packages...\n'
sudo xbps-install -y $testing ${packages[@]}

# If exit status equals success 0 OK! If not, exit with error status 1 
if [[ $? == 0 ]]; then
    echo -e 'Complete package install!\n'
else
    echo -e 'Error! Exiting...\n'
    exit 1
fi

echo 'Configure system...'

# Config keyboard and touchpad
echo 'Keyboard and touchpad setup...'
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp -r xorg.conf.d/* /etc/X11/xorg.conf.d/

# Create folders and copy settings
# ~/.config folder
echo 'Copy settings to .config...'
mkdir -p $HOME/.config
cp -r config/* $HOME/.config/

# Hidden files in HOME
echo 'Copy hidden files of home...'
for f in home/*; do
    cp -r $f "$HOME/.${f##*/}"
done

# Folder to personal scripts
echo 'Copy bin folder...'
mkdir -p $HOME/bin
cp -r bin/* $HOME/bin/

# Add custom prompt, shopts, alias, etc...
echo 'Source bash_xw...'
if grep '~/.bash_xw' $HOME/.bashrc &> /dev/null; then
	echo 'bash_xw is already set!'
else
	echo -e '\n[[ -f ~/.bash_xw ]] && source ~/.bash_xw' >> $HOME/.bashrc
fi

# Change papirus-icon color
echo 'Set papirus-icon color...'
sudo papirus-folders -C indigo

# Create user folders
echo 'Create user folders...'
xdg-user-dirs-update

# Create .xinitrc
echo 'Create .xinitrc ...\n'
if [[  -f $HOME/.xinitrc ]] 2> /dev/null; then
	echo 'There is already a .xinitrc'
else
	echo 'nexec dbus-launch --exit-with-session bspwm' >> $HOME/.xinitrc
fi

# Finish and reboot
echo 'Setup complete...'
read 'Press Enter to continue...' continues
sudo reboot

