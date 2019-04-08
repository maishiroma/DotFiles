#!/bin/bash
# This script only focuses on configuring vim in the current machine

# This top part is all about putting a help flag
usage="$(basename "$0") [-h] -- Automatically configures vim to work on any instance!

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
echo "Welcome to Matt's Vim DotFile Installation! This script will automate the personal configuration of vim to how Matt likes it."
echo
echo "What kind of actions are you looking for:"
echo "1) New Installation"
echo "2) Update"
read -p "Please select an option number: " userInput

if [ $userInput -eq 1 ]; then

  # We do the complete installation of our files
  echo
  echo "Here is a list of all of the changes that will happen:"
  echo "1) Add the .vimrc into the HOME directory"
  echo "2) Install pathogen and Autoclose plugin"
  echo "3) Putting in the Iceberg theme" 
  echo "4) Setting up the .vim folder hierarchy"
  echo
  echo "WARNING! If there already exists a .vim or a .vimrc, its contents will NOT be carried over. (A backup of it will be made)"
  read -p "Are these changes ok? Only yes will be accepted: " userInput

  if [ $userInput = 'yes' ]; then
  
    # If there already exists a .vim folder, we will rename it so that it won't be overriden
    if [ -d ~/.vim ]; then
      newDirName=".vim_backup_$RANDOM"
      mv ~/.vim ~/$newDirName
      echo "Found an existing .vim directory! Renamed it to $newDirName..."
    fi

    # If there exists a .vimrc, we rename it so that it will not be overwritten
    if [ -f ~/.vimrc ]; then
      newFileName=".vimrc_backup_$RANDOM"
      mv ~/.vimrc ~/$newFileName
      echo "Found an existing .vimrc directory! Renamed it to $newFileName..."
    fi

    # We set up our vim folder
    mkdir -p ~/.vim  
    mkdir -p ~/.vim/autoload 
    mkdir -p ~/.vim/bundle
    mkdir -p ~/.vim/colors
    mkdir -p ~/.vim/backup
    mkdir -p ~/.vim/plugin

    # Installs all of out plugins, themes, and .vimrc
    cp ../vimrc ~/.vimrc
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    curl -LSso ~/.vim/plugin/autoclose.vim https://www.vim.org/scripts/download_script.php?src_id=10873
    curl -LSso ~/.vim/colors/iceberg.vim https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim

    echo "Installation complete! Refer to the README in the scripts folder for a post install update."
  else
    echo "Terminating script..."
    exit 0
  fi
elif [ $userInput -eq 2 ]; then
  
  # We update our local .vim with new things
  echo
  echo "Here are a list of all of the things that will be updated:"
  echo "1) The .vimrc file"
  echo
  echo "WARNING: Any changes made locally to .vimrc will be overwritten!"
  read -p "Are these changes ok? Only yes will be accepted: " userInput

  if [ $userInput = 'yes' ]; then

    # We check if we have a .vim folder
    if [ ! -d ~/.vim ]; then
      echo "There does NOT exist a .vim! Please run option 1 when running this script!"
      echo "Now exiting this script..."
      exit 0
    fi

    # We override the .vimrc that exists and check for the installation of any new plugins
    cp ../vimrc ~/.vimrc
    echo "Update completed! Refer to the vim plugins section in .vimrc to see what else is needed."
  else
    echo "Terminating script..."
    exit 0
  fi
else
  echo "Invalid option! The script will exit..."
  exit 0
fi
