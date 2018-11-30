#!/bin/bash
# This script installs the necessary components in using zsh and configuring it how it should be.
# For this, I am going to presume that this is going to be done ONLY on a brand NEW computer/system

# Prerequesites
# Git, zsh, Oh-My-Zsh, pathogen

echo "Welcome to the script, I am your guide"
echo "I will be installing all of the prereqs that are needed for this repo to work properly"
echo "Now doing preinstall checks..."

# Checks if git is installed
if [ hash git 2>/dev/null ]; then
  echo "Git is installed!"
else
  echo "Git is NOT installed! Please install git! (speaking of which HOW did you even download this repo?)"
  echo "You can find it either by doing 'git --version' on a MacOS or 'sudo apt install git-all' on a Linux Distro."
  exit 127
fi

# Checks if zsh is installed
if [ hash zsh 2>/dev/null ]; then
  echo "zsh is installed!"
else
  echo "zsh is NOT installed! Please install zsh!"
  echo "You can get this by using Homebrew on MacOS (brew install zsh zsh-completions) or the packet manager on most Linux distros(apt install zsh)"
  echo "If you don't have Homebrew, run this command: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)""
  exit 127
fi

# Checks if brew is installed
if [ hash brew 2>/dev/null ]; then
  echo "brew is installed!"
else
  echo "brew is NOT installed! Please install brew!"
  echo "Run this command: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)""
  exit 127
fi

# Installing Oh-My-Zsh:  https://github.com/robbyrussell/oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install the Iceberg theme
mkdir -p ~/.vim/colors
curl -LSso ~/.vim/colors/iceberg.vim https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim

# Installs RCM, a dotfile manager: https://github.com/thoughtbot/rcm
brew tap thoughtbot/formulae
brew install rcm

# Installs all of the dotfiles using RCM: https://github.com/thoughtbot/dotfiles
env RCRC=./rcrc rcup
