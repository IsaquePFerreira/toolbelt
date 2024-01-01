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

echo

echo -e 'Copy settings to .config...\n'
mkdir -p $HOME/.config
cp -r config/* $HOME/.config/

echo -e 'Copy hidden files of home...\n'
for f in home/*; do
    cp -r $f "$HOME/.${f##*/}"
done

echo -e 'Create user folders...\n'
xdg-user-dirs-update

echo -e 'startx setup...\n'
echo 'exec dbus-launch --exit-with-session bspwm' >> ~/.xinitrc

sudo reboot
