#!/bin/bash

echo "install necessary packages..."
sudo apt install git make gawk -y

if [[ ! -d $HOME/ble.sh ]]; then
  git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
fi

echo "compile bles.sh..."
make -C ble.sh install PREFIX=~/.local

echo "persist setup in bash file..."
echo 'source ~/.local/share/blesh/ble.sh' >>~/.bashrc

echo "source bashrc file..."
source "$HOME/.bashrc"
