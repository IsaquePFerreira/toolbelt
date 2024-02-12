#!/bin/bash

# testing='--dry-run'

clear

echo -e 'Update system...\n'
sudo xbps-install -Suy

if [[ $? == 0 ]]; then
    echo -e '\nComplete system update!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

packages=$(sed -e '/^\s*#/g' -e '/^\s*$/g' packages.txt | tr '\n' ' ')

echo -e 'Install some packages...\n'
sudo xbps-install -Sy $testing ${packages[@]}

if [[ $? == 0 ]]; then
    echo -e '\nComplete package install!\n'
else
    echo -e '\nError! Exiting...\n'
    exit 1
fi

clear

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
cp -r bin ~/bin

echo -e 'Create user folders...\n'
xdg-user-dirs-update

echo -e 'Startx setup...\n'
echo 'exec dbus-launch --exit-with-session bspwm' >> ~/.xinitrc

echo -e 'Setup complete...\n'
read -p 'Press Enter to reboot...' continues

sudo reboot
