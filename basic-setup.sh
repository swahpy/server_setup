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
if [[ -z "${ZSH}" ]]; then
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
fi
echo "     Install zsh plugins..."
ZSH_SYNTAX_HIGHLIGHTING="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
ZSH_AUTOSUGGESTIONS="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
ZSH_Z="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-z

if [[ ! -d "$ZSH_SYNTAX_HIGHLIGHTING" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING"
fi
if [[ ! -d "$ZSH_AUTOSUGGESTIONS" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS"
fi
if [[ ! -d "$ZSH_Z" ]]; then
  git clone https://github.com/agkozak/zsh-z "$ZSH_Z"
fi
sed 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)/g' "$HOME"/.zshrc
## ╔══════════════════════════════════╗
## ║   Install and setup starship     ║
## ╚══════════════════════════════════╝
echo "[2]. Begin starship installation and setup"
curl -sS https://starship.rs/install.sh | sh
echo eval "$(starship init zsh)" >> "$HOME"/.zshrc
source "$HOME"/.zshrc
