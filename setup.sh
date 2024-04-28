#!/bin/bash

# testing='--dry-run'

version="${0##*/} version 0.2"

source ./packages

echo -e 'Update system...\n'
sudo xbps-install -Suy

if [[ $? == 0 ]]; then
    echo -e '\nComplete system update!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

echo -e 'Install some packages...\n'
sudo xbps-install -y $testing ${packages[@]}

if [[ $? == 0 ]]; then
    echo -e '\nComplete package install!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

echo 'Configure system...'

echo -e '\nCopy settings to .config...\n'
mkdir -p $HOME/.config
cp -r config/* $HOME/.config/

echo -e 'Copy hidden files of home...\n'
for f in home/*; do
    cp -r $f "$HOME/.${f##*/}"
done

echo -e 'Source bash_xw...\n'
echo -e '\n[[ -f ~/.bash_xw ]] && source ~/.bash_xw' >> $HOME/.bashrc

echo -e 'Copy bin folder...\n'
mkdir -p $HOME/.bin
cp -r bin/* $HOME/.bin/

echo -e 'Create user folders...\n'
xdg-user-dirs-update

echo -e 'Setup complete...\n'
read -p 'Press Enter to continue...' continues
reboot

