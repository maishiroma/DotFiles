#!/bin/bash
# This script is the basis on how these DotFiles should be configured
# This is done exclusively on a brand new MacOS environment
# In order to get this to work, we will need to have git and zsh installed already

# This top part is all about putting a help flag
usage="$(basename "$0") [-h] -- Smartly places and configures these Dot files in the home directory of the current computer.

    -h  displays help on this script
    
PREREQS:
  In order for this script to run properly, you will need to have the following installed:
    git
    brew
    zsh
    .oh-my-zsh
"

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

# The actual work on the script
echo "Welcome to the MacOS Installer Script for Matt DotFiles, I am your guide."
echo "Before we begin, I will perform some checks to see if the required software is installed."

echo
echo "Now checking if git is installed..."
# Checks if git is installed
if hash git 2>/dev/null; then
  echo "Git is installed!"
else
  echo "Git is NOT installed! Please install git! (speaking of which HOW did you even download this repo?)"
  echo "Run <git --version> and follow the on screen prompts."
  exit 127
fi

echo
echo "Now checking if brew is installed..."
# Checks if brew is installed
if hash brew 2>/dev/null; then
  echo "brew is installed!"
else
  echo "brew is NOT installed! Please install brew!"
  echo "Run: <ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\" to install brew."
  exit 127
fi

echo
echo "Now checking if zsh and Oh My ZSH is installed"
# Checks if zsh and oh my zsh is installed
if hash zsh 2>/dev/null; then
  echo "zsh is installed!"
else
  echo "zsh is NOT installed! Please install zsh!"
  echo "Run: <brew install zsh zsh-completions> to install zsh."
  exit 127
fi
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My zsh is installed!"
else
  echo "Oh My zsh is not installed!"
  echo "To install, run: <sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\"> "
  exit 127
fi

echo
echo
echo "Preflight checks completed! We wil begin installing the necessary components to get Matt Dotfiles all sorted out."

echo
echo "What gitconfig do you want to use? Please specify a number."
echo "1) Personal"
echo "2) Work"
read userInput

echo
if [ $userInput -eq 2 ]; then
  cp ../gitConfigs/gitconfig_work ../gitconfig
else
  cp ../gitConfigs/gitconfig_personal ../gitconfig
fi

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
env RCRC=../rcrc rcup

echo "Installation complete! Please run a new terminal session to get the new changes."
