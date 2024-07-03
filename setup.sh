#!/bin/bash

# Uncomment this line to testing mode in package manager
testing='--dry-run'

# Package list
packages=(
xorg
libXft-devel
libX11-devel
libXinerama-devel
libXrender-devel
dbus
polkit
elogind
# xfce4
# bspwm
sxhkd
# rofi
dmenu
# polybar
xfce4-terminal
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
    echo -e '\nComplete package install!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

# Config keyboard and touchpad
sudo mkdir -p /etc/X11/xorg.conf.d
sudo cp -r xorg.conf.d/* /etc/X11/xorg.conf.d/

# Create folders and copy settings
echo 'Configure system...'

# ~/.config folder
echo -e '\nCopy settings to .config...\n'
mkdir -p $HOME/.config
cp -r config/* $HOME/.config/

# Hidden files in HOME
echo -e 'Copy hidden files of home...\n'
for f in home/*; do
    cp -r $f "$HOME/.${f##*/}"
done

# Folder to personal scripts
echo -e 'Copy bin folder...\n'
mkdir -p $HOME/bin
cp -r bin/* $HOME/bin/

# Add custom prompt, shopts, alias, etc...
echo -e 'Source bash_xw...\n'
echo -e '\n[[ -f ~/.bash_xw ]] && source ~/.bash_xw' >> $HOME/.bashrc

# Create user folders
echo -e 'Create user folders...\n'
xdg-user-dirs-update

# Create .xinitrc
echo -e 'Create user folders...\n'
echo -e '\n\nexec dbus-launch --exit-with-session bspwm' >> .xinitrc

# Finish and reboot
echo -e 'Setup complete...\n'
read -p 'Press Enter to continue...' continues
sudo reboot

