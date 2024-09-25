#!/usr/bin/env bash

# exits upon failures, instead of continuing
set -o errexit

# fails when accessing unset variables
set -o nounset

# fails a pipeline when one command fails
set -o pipefail

# enable debug mode
if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

# change to the script directory when running it
cd "$(dirname "$0")"

## ╔══════════════════════════════════╗
## ║       Install and setup zsh      ║
## ╚══════════════════════════════════╝
echo "[1]. Begin zsh installation and setup"
echo "     Ensure zsh is installed..."
if [[ -f "/etc/os-release" ]]; then
  . /etc/os-release
  case "$ID" in
  ubuntu)
    sudo apt update && sudo apt install -y zsh
    ;;
  sles)
    sudo zypper in -y zsh
    ;;
  *)
    echo "OS $ID is not supported..." >&2
    ;;
  esac
fi
echo "     Install oh-my-zsh..."
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
echo "     Install zsh plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone https://github.com/agkozak/zsh-z "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-z
sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)' "$HOME"/.zshrc
## ╔══════════════════════════════════╗
## ║   Install and setup starship     ║
## ╚══════════════════════════════════╝
curl -sS https://starship.rs/install.sh | sh
echo eval "$(starship init zsh)" >> "$HOME"/.zshrc
source "$HOME"/.zshrc
