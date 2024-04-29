#!/bin/bash

# testing='--dry-run'

# version="${0##*/} version 0.2"

# Import package list
source ./packages

# Run sync and upgrade
echo -e 'Update system...\n'
sudo xbps-install -Suy

if [[ $? == 0 ]]; then
    echo -e '\nComplete system update!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

# Install some packages
echo -e 'Install some packages...\n'
sudo xbps-install -y $testing ${packages[@]}

if [[ $? == 0 ]]; then
    echo -e '\nComplete package install!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

# Create folders and copy settings
echo 'Configure system...'

echo -e '\nCopy settings to .config...\n'
mkdir -p $HOME/.config
cp -r config/* $HOME/.config/

echo -e 'Copy hidden files of home...\n'
for f in home/*; do
    cp -r $f "$HOME/.${f##*/}"
done

echo -e 'Copy bin folder...\n'
mkdir -p $HOME/.bin
cp -r bin/* $HOME/.bin/

# Add custom prompt, shopts, alias, etc...
echo -e 'Source bash_xw...\n'
echo -e '\n[[ -f ~/.bash_xw ]] && source ~/.bash_xw' >> $HOME/.bashrc

# Create user folders
echo -e 'Create user folders...\n'
xdg-user-dirs-update

# Finish and reboot
echo -e 'Setup complete...\n'
read -p 'Press Enter to continue...' continues
reboot

