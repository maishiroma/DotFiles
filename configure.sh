#!/bin/bash
set -e
# The install script for my dot files! 
# Idea is to use symlinks to have it where my configs are pointed to this repository for easy managing.
# No need to install additional software, just run this and it should be done.

### Functions

## Helper Functions

# Prints out the help function of the script
usage () {
    cat << EOF
$(basename "$0") [-odh] -- Configures a personal system using maishiroma's dot files.

This script aims to simplify the process of bringing onboard a new system. Currently, there are two available options that can be passed in the -o flag:
    
    personal (My personal configs)
    work     (What my work laptop has for configs)

FLAGS:
    -o:     Specifies which kind of dotfiles to leverage (REQUIRED)
    -n:     Specifies a new binary to update for that particular symlink
    -d:     Enabled delete mode on this script
    -h:     Shows this help page

EXAMPLE:
    1.) ./configure.sh -o personal
        Configures a new installation of dot files using the personal configs and binaries

    2.) ./configure.sh -d
        Removes the current installation of dot files on the system
    
    3.) ./configure.sh -o work -n someBinary
        Updates the symlink for a binary to utilize the specified binary in the work config
EOF
}

# Checks if the user wants to proceed. If not, the script will end
confirm_user() {
    echo "Are you sure you want to proceed?"
    echo "Please confirm with 'yes': "
    read userInput

    if [ "${userInput}" != "yes" ]; then
        echo "Aborting script safely."
        exit 0
    fi
}

# Downloads the binary that is specified, validating its validity
# Parameters: $1=newBinaryPath, $2=fileName
# newBinaryPath: The path that leads to the file that contains the download link to the binary and a SHA
# fileName: The name of the binary that will be utilized
download_new_binary() {
    fileURL=$(head -1 $1)
    fileSHA=$(tail -1 $1)
    packageName=$(echo ${FILE##/*/})

    curl -LSso ~/CLI_Tools/$2.zip ${fileURL}
    if [ $(sha256 "~/CLI_Tools/$2.zip") != "${fileSHA}" ]; then
        echo "$2 didn't seem to be valid, skipping..."
    else
        unzip ~/CLI_Tools/$2.zip -d ~/CLI_Tools/$2
        echo "Sucessfully validated and downloaded binary, into ~/CLI_Tools/$2"
    fi
    rm ~/CLI_Tools/$2.zip
}

## Main Logic Functions

# Checks the system if the pre-requirements are installed:
# Specifically, git, brew, zsh and Oh my Zsh
pre_dot_checks() {
    echo "Checking if git, brew, zsh, and Oh-my-zsh are installed..."

    if hash git 2>/dev/null; then
        echo "Git is installed!"
    else
        echo "Git is NOT installed! Please install git! (speaking of which HOW did you even download this repo?)"
        echo "Run <git --version> and follow the on screen prompts."
        exit 1
    fi
    
    if hash brew 2>/dev/null; then
        echo "brew is installed!"
    else
        echo "brew is NOT installed! Please install brew!"
        echo "Run: <ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\" to install brew."
        exit 1
    fi

    if hash zsh 2>/dev/null; then
        echo "zsh is installed!"
    else
        echo "zsh is NOT installed! Please install zsh!"
        echo "Run: <brew install zsh zsh-completions> to install zsh."
        exit 1
    fi
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My zsh is installed!"
    else
        echo "Oh My zsh is not installed!"
        echo "To install, run: <sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\"> "
        exit 1
    fi

    echo "Pre checks complete!"
    echo
}

# Configures vim by creating the needed dirs
vim_pre_config () {
    echo "Checking if .vim dirs are created..."

    if [ -d "~/.vim/autoload" ]; then
        echo "Creating ~/.vim/autoload"
        mkdir -p ~/.vim/autoload
    fi
    
    if [ -d "~/.vim/bundle" ]; then
        echo "Creating ~/.vim/bundle"
        mkdir -p ~/.vim/bundle
    fi

    if [ -d "~/.vim/plugin" ]; then
        echo "Creating ~/.vim/plugin"
        mkdir -p ~/.vim/plugin
    fi
    
    if [ -d "~/.vim/backup" ]; then
        echo "Creating ~/.vim/backup"
        mkdir -p ~/.vim/backup
    fi 

    if [ -d "~/.vim/colors" ]; then
        echo "Creating ~/.vim/colors"
        mkdir -p ~/.vim/colors
    fi

    echo "Finished checking .vim dirs"
    echo
}

# Installs all plugins for vim
vim_install_plugins_themes() {
    echo "Installing Vim plugins and themes..."

    if [ -f "~/.vim/autoload/pathogen.vim" ]; then
        # Install pathogen
        echo "Installing Pathogen to ~/.vim/autoload/pathogen.vim ..."
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    fi

    if [ -f "~/.vim/colors/iceberg.vim" ]; then
        # Install the Iceberg theme
        echo "Installing Iceberg theme to ~/.vim/colors/iceberg.vim ..."
        curl -LSso ~/.vim/colors/iceberg.vim https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim
    fi

    if [ -f "~/.vim/plugin/autoclose.vim" ]; then
        # Installs autoclose plugin
        echo "Installing autoclose plugin to ~/.vim/plugin/autoclose.vim ..."
        curl -LSso ~/.vim/plugin/autoclose.vim https://www.vim.org/scripts/download_script.php?src_id=10873
    fi

    # If we are on a specific environment, we install additional plugins
    if [ "${TYPE}" == "work" ]; then
        if [ -d "~/.vim/bundle/vim-terraform" ]; then
            # Installs vim-terraform plugin
            echo "Installing vim-terraform plugin to ~/.vim/bundle/vim-terraform ..."
            mkdir -p ~/.vim/bundle/vim-terraform
            git clone git@github.com:hashivim/vim-terraform.git ~/.vim/bundle/vim-terraform
        fi
        
        if [ -d "~/.vim/bundle/vim-markdown-preview" ]; then
            # Installs vim-markdown-preview plugin
            echo "Installing vim-markdown-preview plugin to ~/.vim/bundle/vim-markdown-preview ..."
            mkdir -p ~/.vim/bundle/vim-markdown-preview
            git clone git@github.com:JamshedVesuna/vim-markdown-preview.git ~/.vim/bundle/vim-markdown-preview
        fi
    fi

    echo "Installation of all plugins complete!"
    echo
}

# Installs additional packages that are leveraged from the terminal
terminal_install_pkgs() {
    echo "Now checking if there's additional terminal packages needed..."

    # Checks for zsh-autosuggestions plugin
    if [ -d "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions into ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions..."
        mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        git clone git@github.com:zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    echo "Finished installing terminal plugins!"
    echo
}

# Symlinks all needed config files to their respectible places, depending on the flag, TYPE
create_config_symlinks() {
    dir_loc=""
    if [ "${TYPE}" == "personal" ]; then
        echo "Symlinking configs from the personal directory..."
        dir_loc="$(pwd)/personal"
    elif [ "${TYPE}" == "work" ]; then
        echo "Symlinking configs from the work directory..."
        dir_loc="$(pwd)/work"
    else
        echo "That option is not valid here, sorry! Try asking for help. :)"
        exit 1
    fi

    echo "The following files will now be symlinked to this repo: ~/.gitconfig, ~/.tmux.conf, ~/.zshrc, ~/.zsh_exports, ~/.vimrc"
    confirm_user

    ln -sf ${dir_loc}/git/gitconfig ~/.gitconfig
    
    ln -sf ${dir_loc}/terminal/tmux.conf ~/.tmux.conf
    ln -sf ${dir_loc}/terminal/zshrc ~/.zshrc
    ln -sf ${dir_loc}/terminal/zsh_exports ~/.zsh_exports
    
    ln -sf ${dir_loc}/vim/vimrc ~/.vimrc

    echo "Finished symlinking configs."
    echo
}

# Removes symlinks that are on the current system
delete_config_symlinks() {
    echo "The following symlinks will be removed: ~/.gitconfig, ~/.tmux.conf, ~/.zshrc, ~/.zsh_exports, ~/.vimrc"
    confirm_user

    echo "Removing symlinks/files mentioned..."
    # If file/symblink is already removed, we will skip that step
    if [ ! -f "~/.gitconfig" ]; then
        rm ~/.gitconfig
    fi
    if [ ! -f "~/.tmux.conf" ]; then
        rm ~/.tmux.conf
    fi
    if [ ! -f "~/.zshrc" ]; then
        rm ~/.zshrc
    fi
    if [ ! -f "~/.zsh_exports" ]; then
        rm ~/.zsh_exports
    fi
    if [ ! -f "~/.vimrc" ]; then
        rm ~/.vimrc
    fi

    echo "Removed all symlinks/files."
    echo
}

# Creates symlinks to specific binaries
create_binary_symlinks() {
    dir_loc=""
    if [ "${TYPE}" == "personal" ]; then
        echo "Utilizing binaries from the personal directory..."
        dir_loc="$(pwd)/personal/binaries"
    elif [ "${TYPE}" == "work" ]; then
        echo "Utilizing binaries from from the work directory..."
        dir_loc="$(pwd)/work/binaries"
        echo
    else
        echo "That option is not valid here, sorry! Try asking for help. :)"
        exit 1
    fi

    echo "The specified binaries will be downloaded and verified in ~/CLI_Tools and symlinked in ~/bin_symlinks: "
    ls ${dir_loc}
    confirm_user

    # Creates needed dirs if they do not exist
    if [ -d "~/CLI_Tools" ]; then
        echo "Creating ~/CLI_Tools..."
        mkdir -p ~/CLI_Tools
    fi
    if [ -d "~/bin_symlinks" ]; then
        echo "Creating ~/bin_symlinks..."
        mkdir -p ~/bin_symlinks
    fi

    # Downloads, verifies, and symlinks binaries to ~/binary_symlinks
    for currBinaryPath in "${dir_loc}"/* 
    do
        fileName=$(basename -- "${currBinaryPath}")
        fileName="${fileName%.*}"
        binaryName=$(echo ${fileName} | cut -d '_' -f 1)

        download_new_binary "${currBinaryPath}" "${fileName}"
        ln -sf ${HOME}/CLI_Tools/${fileName} ~/bin_symlinks/${binaryName}

        echo "Successfully made binary symlink, ${binaryName}, in ~/bin_symlinks/${binaryName}"
    done

    echo "Finished setting up all binary symlinks to system. Please verify that your PATH contains: $(pwd)/binary_symlinks"
}

# Deletes all binary symlinks
delete_binary_symlinks() {
    if [ -d "~/bin_symlinks" ]; then
        echo "There are no symlinks to delete! Exiting..."
        exit 1
    fi
    
    echo "The following symlinks will be removed: "
    ls ~/bin_symlinks
    confirm_user

    rm -f /bin_symlinks/*
    echo "All symlinks removed! To remove binaries, those need to be manually removed from ~/CLI_Tools."
}

# Takes in a new binary, removes a corresponding one, and adds it in
# Taken from a simlar vein to how stow does it
update_binary_symlinks() {
    if [[ -d "~/CLI_Tools" ]]  || [[ -d "~/bin_symlinks" ]]; then
        echo "There are missing directories! Exiting..."
        exit 1
    fi

    dir_loc=""
    if [ "${TYPE}" == "personal" ]; then
        echo "Utilizing binaries from the personal directory..."
        dir_loc="$(pwd)/personal/binaries"
    elif [ "${TYPE}" == "work" ]; then
        echo "Utilizing binaries from from the work directory..."
        dir_loc="$(pwd)/work/binaries"
    else
        echo "That option is not valid here, sorry! Try asking for help. :)"
        exit 1
    fi

    newBinaryFile="${dir_loc}/${NEW_BINARY_NAME}.tmp"
    newBinaryNameNoVer=$(echo ${NEW_BINARY_NAME} | cut -d '_' -f 1)
    oldBinaryName=$(basename $(readlink ${newBinaryNameNoVer}))

    echo "We are going to download the new binary (if needed) and reconfigure the symlink of ${newBinaryNameNoVer}."
    echo "OLD: ${oldBinaryName}"
    echo "NEW: ${NEW_BINARY_NAME}"
    confirm_user
    
    if [ -d "~/CLI_Tools/${NEW_BINARY_NAME}" ]; then
        echo "${NEW_BINARY_NAME} not found in ~/CLI_Tools. Will be downloading a copy..."
        download_new_binary "${newBinaryFile}" "${NEW_BINARY_NAME}"
    fi
    
    ln -sf ${HOME}/CLI_Tools/${NEW_BINARY_NAME} ~/bin_symlinks/${newBinaryNameNoVer}
    echo "Sucessfully updated symlink to use ${NEW_BINARY_NAME}."
}

### Main
while getopts 'n:o:dh' option; do
    case "$option" in
        d)
            DELETE_MODE=true
            ;;
        o)
            TYPE=("$OPTARG")
            ;;
        n)
            NEW_BINARY_NAME=("$OPTARG")
            ;;
        h) 
            usage
            exit 0
            ;;
        \?) 
            printf "illegal option: -%s\n" "$OPTARG" >&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

# Main logic loop
if [ -n "${DELETE_MODE}" ]; then
    # We are going to delete the symlinks from the system
    echo "Preparing to deleting current dotfiles on system..."
    delete_config_symlinks
    delete_binary_symlinks
    echo "Deletion complete!"

elif [ -n "${TYPE}" ]; then
    if [ -n "${NEW_BINARY_NAME}" ]; then
        # We are going to update an existing symlink
        echo "Preparing symlink update..."
        update_binary_symlinks
        echo "Update complete!"

    else
        # We are going to install the symlinks onto the system
        # First, run prechecks and preconfigs
        echo "Preparing to install dotfiles on system..."
        pre_dot_checks
        vim_pre_config

        # Then create symlinks and installs packages
        create_config_symlinks
        vim_install_plugins_themes
        terminal_install_pkgs

        # We are also going to install binary symlinks
        create_config_symlinks

        echo "Installation complete! To reload the configuation, start a new terminal session."
    fi

elif [ -z "${TYPE}" ]; then
    echo "The -o flag needs to be specified when doing an install. Please look at the -h for more help"
    exit 1
fi
