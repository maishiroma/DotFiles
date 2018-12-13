#!/bin/bash
# This script is if you are really lazy and do not want to do anything complicated with putting your dot files on your new computer
# Only use this if you know that you are not intrested in managing any dot file manager

# Summary: This script copies and places the dot files from the repo in the user's home directory.

# This top part is all about putting a help flag
usage="$(basename "$0") [-h] -- Manually copies the dot files found in this repo to the user's HOME directory

    -h  displays help on this script

NOTE: IF you want to update the dot files from whatever is in the repo, simple run this script again."

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
echo "Welcome to the manual script. This is for those who just want to get straight to the point."
echo "WARNING! This is highly destructive; this will OVERRIDE the following dot files that are currently in your HOME directory:"
echo
echo ".gitignore"
echo ".bash_profile"
echo ".vimrc"
echo ".zsh_exports"
echo ".zshrc"

echo
echo "This script will also add in Pathogen and a theme for vim, if the .vim directory is not found."
echo
echo

read -p 'Do you want to procceed? Only "yes" will be accepted: ' userData

if [ $userData = "yes" ]; then

  # We are using the environment Variable $HOME. IF this is not set, we fail this script
  if [ $HOME = "" ]; then
    echo "ERROR! You do not have a HOME variable! Please set it first."
    exit 127
  else

    # We first decide which gitignore to use
    echo
    echo "1) Personal"
    echo "2) Work"
    read -p "What gitconfig do you want to use? Please specify an option: " userInput
    if [ $userInput -eq 2 ]; then
      cp ../gitConfigs/gitconfig_work $HOME/.gitconfig
      echo "Successfully added work gitconfig!"
    else
      cp ../gitConfigs/gitconfig_personal $HOME/.gitconfig
      echo "Successfully added personal gitconfig!"
    fi

    echo
    # For .vimrc, we need two additional files: pathogen and iceberg
    if [ -d "$HOME/.vim" ]; then
      echo ".vim directory already exists in $HOME. Skipping preflight vim config..."
    else
      echo ".vim folder not found in $HOME. Now configuring system to have .vim directory..."
      mkdir -p ~/.vim/autoload ~/.vim/bundle && \
      mkdir -p ~/.vim/colors

      curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
      echo "Successfully added pathogen!"

      curl -LSso ~/.vim/colors/iceberg.vim https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim
      echo "Successfully added iceberg theme for vim!"
    fi

    echo
    # We then move the rest of the necessary dotfiles
    cp ../bash_profile $HOME/.bash_profile
    echo "Successfully added .bash_profile!"
    
    cp ../vimrc $HOME/.vimrc
    echo "Successfully added .vimrc!"
    
    cp ../zsh_exports $HOME/.zsh_exports
    echo "Successfully added .zsh_exports!"
    
    cp ../zshrc $HOME/.zshrc
    echo "Successfully added .zshrc!"
    
    echo
    echo "COMPLETED! You are now me now! :)"
  fi
else
  echo "Exiting script from user input..."
  exit 0
fi
