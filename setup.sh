#!/bin/bash

# Uncomment this line to testing mode in package manager
# testing='--dry-run'

# Package list
source packages

set -e

# Update system
echo -e 'Update system...\n'
sudo xbps-install -Suy $testing

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
sudo cp -ruv xorg.conf.d/* /etc/X11/xorg.conf.d/

# Create folders and copy settings
# ~/.config folder
echo 'Copy settings to .config...'
mkdir -p $HOME/.config
cp -ruv config/* $HOME/.config/

# Hidden files in HOME
echo 'Copy hidden files of home...'
for f in home/*; do
    cp -ruv $f "$HOME/.${f##*/}"
done

# Folder to personal scripts
echo 'Copy bin folder...'
mkdir -p $HOME/bin
cp -ruv bin/* $HOME/bin/

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
	echo 'exec dbus-launch --exit-with-session bspwm' >> $HOME/.xinitrc
fi

# Finish and reboot
echo 'Setup complete...'
read -p 'Press Enter to continue...' continues
sudo reboot
