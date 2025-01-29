#!/bin/bash
#
# settings.sh
#
# Programa para automatizar a configuração inicial de um ambiente de
# desenvolvimento.
#
# Exemplo de uso:
# 
# ./settings.sh --all
#

# Caminho para a pasta dotfiles no home do usuário
_DOT_DIR="$HOME/.local/share/dotfiles"
_CONFIG_DIR="$_DOT_DIR/config"
_BIN_DIR="$_DOT_DIR/bin"
_HIDDEN_FILES_DIR="$_DOT_DIR/home"

# Carrega a lista de pacotes que vão ser instalados
source "$_DOT_DIR/PACKAGES"

# Instala pacotes necessários
req_pkgs() {
    echo 'Install some packages...'
    sudo apt install -y "${PACKAGES[@]}"
}

# Copie fontes para diretório no home do usuário e atualiza o cache de fontes
set_fonts() {
    echo 'Copy fonts...'
    mkdir -pv $HOME/.local/share/fonts
    # TODO Corrige função set_fonts
    # cp -ruv $_DOT_DIR/fonts/* $HOME/.local/share/fonts/
    fc-cache -fv
}

# Baixa wallpapers e copia para ~/Pictures
set_wallpapers() {
    echo 'Download wallpapers...'
    cd /tmp
    [[ -d wallpapers ]] && rm -rf wallpapers
    git clone https://github.com/IsaquePFerreira/wallpapers
    echo 'Copy wallpapers...'
    mkdir -pv $HOME/Pictures/wallpapers
    cp -ruv wallpapers/* $HOME/Pictures/wallpapers/
}

# Copia configurações
set_configs() {
    echo 'Set configs...'
    mkdir -pv $HOME/.config
    cp -ruv "$_CONFIG_DIR/*" $HOME/.config/
}

# Copia arquivos ocultos que ficam no home do usuário
set_home_hidden_files() {
    echo 'Copy hidden files of home...'
    for f in "$_HIDDEN_FILES_DIR/*"; do
        # Para cada arquivo $f adiciono o '.' no inicio do nome
        cp -ruv $f "$HOME/.${f##*/}"
    done

    echo 'Source bash_aliases...'
    # Verifica se já tem o treco que faz o 'source' do arquivo bash_aliases
    if grep '~/.bash_aliases' $HOME/.bashrc &> /dev/null; then
        echo 'bash_aliases is already set!'
    else
        echo -e '\n[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases' >> $HOME/.bashrc
    fi
}

# Copia pasta de programas
set_bin_folder() {
    echo 'Copy bin folder...'
    mkdir -p $HOME/.local/bin
    cp -ruv "$_BIN_DIR/*" $HOME/.local/bin/
}

# Realizar configuração completa do sistema
config_sys() {
    echo 'Configure system...'
    req_pkgs
    set_fonts
    set_wallpapers
    set_configs
    set_home_hidden_files
    set_bin_folder
    bspc wm -r
    reset && clear && neofetch
}

# Help para ser mais amigável
_help() {
cat << EOF

usage: ${0##*/} [flags]

  Options:

    --all            Complete config system
    --install        Install required packages
    --keyboard       Set keyboard settings
    --config         Set ~/.config
    --home           Set home hidden files
    --bin            Set scripts folder
    --help           Show this is message

EOF
}

# Quando houver algum erro interrompe a execuççao imediatamente
set -e

# Menu maneiro :)
case $@ in
    --all)      config_sys;;
    --install)  req_pkgs;;
    --keyboard) set_keys;;
    --config)   set_configs;;
    --home)     set_home_hidden_files;;
    --bin)      set_bin_folder;;
    --help)     _help;;
    *) echo 'Invalid parameter!' && _help;;
esac
