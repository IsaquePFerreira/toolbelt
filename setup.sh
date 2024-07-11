#!/bin/bash

# Uncomment this line to testing mode in package manager
# testing='--dry-run'

# Package list
source packages

update_sys() {
	echo -e 'Update system...\n'
	sudo xbps-install -Suy $testing	
}

install_pkgs() {
	echo -e 'Install some packages...\n'
	sudo xbps-install -y $testing ${packages[@]}
}

config_sys() {
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
	echo 'Create .xinitrc ...'
	if [[  -f $HOME/.xinitrc ]] 2> /dev/null; then
		echo 'There is already a .xinitrc'
	else
		echo 'exec bspwm' >> $HOME/.xinitrc
	fi

	# Set default wallpaper
	# echo 'Set wallpaper...'
	# feh --bg-scale wall015.jpg
}

post_installation() {
	# Update system
	update_sys
	# If exit status equals success 0 OK! If not, exit with error status 1 
	if [[ $? == 0 ]]; then
		echo -e '\nComplete system update!\n'
	else
		echo -e '\nError! Exiting...\n'
		exit 1
	fi

	# Installing some packages
	install_pkgs
	# If exit status equals success 0 OK! If not, exit with error status 1 
	if [[ $? == 0 ]]; then
		echo -e 'Complete package install!\n'
	else
		echo -e 'Error! Exiting...\n'
		exit 1
	fi

	# Configure system
	config_sys

	# Finish and reboot
	echo 'Setup complete...'
	read -p 'Reboot system?[S/n]' continues
	if [[ ${continues,,} != 'n' ]]; then
		sudo reboot
	fi
}

instructions() {
cat << EOF

usage: ${0##*/} [flags]

  Options:

    --install,-i       	Install packages from package list
    --config-system,-c	Set system configs 
    --post-install,-pi 	Complete setup
    --help,-h          	Show this is message

EOF
}

set -e

case $@ in
	--install|-i) install_pkgs;;
	--config-system|-c) config_sys;;
	--post-install|-pi) post_installation;;
	--help|-h) instructions;;
	*) echo 'Invalid parameter!' && instructions;;
esac
