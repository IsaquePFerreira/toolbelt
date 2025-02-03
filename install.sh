#!/bin/bash
#
# install.sh
#
# Programa para automatizar a configuração inicial de um ambiente de
# desenvolvimento.
#
# Exemplo de uso:
# 
# ./install.sh --all
#

############
# VARIÁVEIS
############
# Urls
FONTS_URL="https://github.com/IsaquePFerreira/fonts"
WALLPAPERS_URL="https://github.com/IsaquePFerreira/wallpapers"

# Baixa e copia as fontes para diretório no home do usuário e
# atualiza o cache de fontes
set_fonts() {
    echo 'Download fonts...'
    cd /tmp
    [[ -d fonts ]] && rm -rf fonts
    git clone "$FONTS_URL"
    echo 'Copy fonts...'
    mkdir -pv $HOME/.local/share/fonts
    cp -ruv fonts/* $HOME/.local/share/fonts/
    fc-cache -fv
}

# Baixa wallpapers e copia para ~/Pictures
set_wallpapers() {
    echo 'Download wallpapers...'
    cd /tmp
    [[ -d wallpapers ]] && rm -rf wallpapers
    git clone "$WALLPAPERS_URL"
    echo 'Copy wallpapers...'
    mkdir -pv $HOME/Pictures/wallpapers
    cp -ruv wallpapers/* $HOME/Pictures/wallpapers/
}

# Copia configurações
set_configs() {
    echo 'Set configs...'
    mkdir -pv $HOME/.config
    cp -ruv config/* $HOME/.config/
}

# Copia arquivos ocultos que ficam no home do usuário
set_home_hidden_files() {
    echo 'Copy hidden files of home...'
    for f in home/*; do
        # Para cada arquivo $f adiciona o '.' no inicio do nome
        cp -ruv $f "$HOME/.${f##*/}"
    done

    # Adiciona o source para arquivo bash_aliases
    echo 'Source bash_aliases...'
    # Verifica se já tem o trecho que faz o 'source' do arquivo bash_aliases
    if grep '~/.bash_aliases' $HOME/.bashrc &> /dev/null; then
        echo 'bash_aliases is already set!'
    else
        echo -e '\n[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases' >> $HOME/.bashrc
    fi
}

# Copia pasta de programas
set_bin_folder() {
    echo 'Copy scripts to ~/.local/bin...'
    mkdir -p $HOME/.local/bin
    cp -ruv bin/* $HOME/.local/bin/
}

# Realizar configuração completa do sistema
config_sys() {
    echo 'Configure system...'
    set_fonts
    set_wallpapers
    set_configs
    set_home_hidden_files
    set_bin_folder
}

# Help para ser mais amigável
_help() {
cat << EOF

usage: ${0##*/} [flags]

  Options:

    --all            Complete config system
    --config         Set ~/.config
    --home           Set home hidden files
    --bin            Set scripts folder
    --help           Show this is message

EOF
}

# Quando houver algum erro interrompe a execução imediatamente
set -e

# Menu maneiro :)
case $@ in
    --all)      config_sys;;
    --config)   set_configs;;
    --home)     set_home_hidden_files;;
    --bin)      set_bin_folder;;
    --help)     _help;;
    *) echo 'Invalid parameter!' && _help;;
esac
