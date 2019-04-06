#!/bin/bash
# This script only focuses on configuring vim in the current machine

# This top part is all about putting a help flag
usage="$(basename "$0") [-h] -- Automatically configures vim to work on any instance!.

    -h  displays help on this script
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

# The actual script
echo "Welcome to Matt's Vim DotFile Installation! This script will modifiy vim and add plugins that he likes in it."
echo
echo "Here is a list of all of the changes that will happen:"
echo "1) Add/Modify .vimrc"
echo "2) Install pathogen and Autoclose Plugin"
echo "3) Putting in the Iceberg theme" 
echo "4) Setting up the .vim folder hierarchy"
echo
echo "Are these changes ok? Only yes will be accepted: "
read userInput

if [ $userInput = 'yes' ]; then
  
  if [ -d "~/.vim" ]; then
    echo "There exists a .vim folder! We will back it up for you..."
    mv ~/.vim ~/.vim_backup
  fi

  # We set up our vim folder
  mkdir -p ~/.vim  
  mkdir -p ~/.vim/autoload 
  mkdir -p ~/.vim/bundle
  mkdir -p ~/.vim/colors
  mkdir -p ~/.vim/backup
  mkdir -p ~/.vim/plugin

  # Moves the vimrc to where .vim is
  cp ../vimrc ~/.vimrc

  # Install pathogen
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

  # Install the Iceberg theme
  curl -LSso ~/.vim/colors/iceberg.vim https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim

  # Installs the autoclose plugin
  curl -LSso ~/.vim/plugin/autoclose.vim https://www.vim.org/scripts/download_script.php?src_id=10873
  
  echo "Installation complete! Refer to the README in the scripts folder for a post install update."
else
  echo "Exiting script..."
fi

