#!/bin/bash
# This script is similar to the vanilla bootstrap script, but this one is for when you are using a brand new Ubuntu computer
# Before running this script, we are presuming git and zsh is installed

echo "Welcome to the Ubuntu Installer Script for Matt DotFiles, I am your guide."
echo "Before we begin, I will perform some checks to see if the required software is installed."

echo "Now checking if git is installed..."
# Checks if git is installed
if hash git 2>/dev/null; then
  echo "Git is installed!"
else
  echo "Git is NOT installed! Please install git! (speaking of which HOW did you even download this repo?)"
  echo "Run <sudo apt install git-all> to get git installed."
  exit 127
fi

echo "Now checking if zsh and Oh My ZSH is installed"
# Checks if zsh and oh my zsh is installed
if hash zsh 2>/dev/null; then
  echo "zsh is installed!"
else
  echo "zsh is NOT installed! Please install zsh!"
  echo "Run: <apt install zsh> to install zsh."
  exit 127
fi
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My zsh is installed!"
else
  echo "Oh My zsh is not installed!"
  echo "To install: <sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"> "
  exit 127
fi

echo "Preflight checks complete! We will begin installing the necessary components to get Matt DotFiles all sorted out."

echo "What gitconfig do you want to use? Please specify a number."
echo "1) Personal"
echo "2) Work"
read userInput

if userInput -eq 2 then
  cp $HOME/DotFiles/gitConfigs/gitconfig_work $HOME/DotFiles/gitconfig
else
  cp $HOME/DotFiles/gitConfigs/gitconfig_personal $HOME/DotFiles/gitconfig
fi

# Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Install the Iceberg theme
mkdir -p ~/.vim/colors
curl -LSso ~/.vim/colors/iceberg.vim https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim

# Installs RCM, a dotfile manager: https://github.com/thoughtbot/rcm
sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
sudo apt-get update
sudo apt-get install rcm

# Installs all of the dotfiles using RCM: https://github.com/thoughtbot/dotfiles
env RCRC=../rcrc rcup

echo "Installation complete! To make sure everything is ok, log in and log out."
