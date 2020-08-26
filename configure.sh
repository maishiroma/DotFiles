#!/bin/bash
set -e
# The install script for my dot files! 
# Idea is to use symlinks to have it where my configs are pointed to this repository for easy managing.
# No need to install additional software, just run this and it should be done.

####### Functions

### Helper Functions

# Prints out the help function of the script
usage () {
    cat << EOF
$(basename "$0") [-o] [-b] [-d] [-h] -- Configures a personal system using maishiroma's dot files.

This script aims to simplify the process of bringing onboard a new system. Currently, there are two available options that can be passed in the -o flag:
    
    personal (My personal configs)
    work     (What my work laptop has for configs)

This script is also a wrapper for managing binary symlinks. While those links are not tied to this, this script helps simplifies the workflow of managing multiple binaries. Note that to use this, binaries MUST be named in the following syntax:

    some-binary_version.number

where "binary-binary" is the name that the binary is referred to (spaces are -), and the version.number is the binary's version.

FLAGS:
    -o:     Specifies which kind of dotfiles to leverage
    -b:     Specifies a binary file to create a symlink towards
    -d:     Enabled delete mode on this script
    -h:     Shows this help page

EXAMPLES:
    1.) ./configure.sh -o personal
        Configures a new installation of dot files using the personal configs

    2.) ./configure.sh -b some-binary_1.0.0
        Creates a symlink to the specified binary

    3.) ./configure.sh -d
        Removes the current installation of dot files on the system

    4) ./configure.sh -d -b some-binary_1.0.0
        Removes the specified binary's symlink, while presenting the option to delete said binary
EOF
}

# Checks if the user wants to proceed. If not, the script will end
confirm_user() {
    echo
    echo "Are you sure you want to proceed?"
    echo "Please confirm with 'yes': "
    read userInput

    if [ "${userInput}" != "yes" ]; then
        echo "Did not receive explicit yes, leaving script..."
        exit 0
    fi
}

### Main Functions

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
    echo "Checking if needed .vim directories are created..."
    echo "The specific .vim directories will be created, if not already existing: autoload, bundle, plugin, backup, and colors."
    confirm_user

    if [ ! -d "$HOME/.vim/autoload" ]; then
        echo "Creating $HOME/.vim/autoload"
        mkdir -p $HOME/.vim/autoload
    fi
    
    if [ ! -d "$HOME/.vim/bundle" ]; then
        echo "Creating $HOME/.vim/bundle"
        mkdir -p $HOME/.vim/bundle
    fi

    if [ ! -d "$HOME/.vim/plugin" ]; then
        echo "Creating $HOME/.vim/plugin"
        mkdir -p $HOME/.vim/plugin
    fi
    
    if [ ! -d "$HOME/.vim/backup" ]; then
        echo "Creating $HOME/.vim/backup"
        mkdir -p $HOME/.vim/backup
    fi 

    if [ ! -d "$HOME/.vim/colors" ]; then
        echo "Creating $HOME/.vim/colors"
        mkdir -p $HOME/.vim/colors
    fi

    echo "Finished configuring .vim directories"
    echo
}

# Sets up the binary symlink directories
prep_binary_symlink_dirs() {
    echo "Checking if needed directories for binary symlinks are present..."
    echo "The following directories will be created, if not existing: ~/CLI_Tools and ~/CLI_Tools/bin_symlinks"
    confirm_user

    if [ ! -d "$HOME/CLI_Tools/bin_symlinks" ]; then
        echo "Creating $HOME/CLI_Tools/bin_symlinks..."
        mkdir -p $HOME/CLI_Tools/bin_symlinks
    fi

    echo "Finished creating binary symlink directories."
    echo
}

# Installs all plugins for vim
vim_install_plugins_themes() {
    echo "Prepping to install Vim plugins and themes..."
    echo "The following plugins will be installed, if not already: pathogen, autoclose"
    echo "The following themes will be installed, if not already: iceberg"
    confirm_user

    if [ ! -f "$HOME/.vim/autoload/pathogen.vim" ]; then
        # Install pathogen
        echo "Installing Pathogen to $HOME/.vim/autoload/pathogen.vim ..."
        curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    fi

    if [ ! -f "$HOME/.vim/colors/iceberg.vim" ]; then
        # Install the Iceberg theme
        echo "Installing Iceberg theme to $HOME/.vim/colors/iceberg.vim ..."
        curl -LSso $HOME/.vim/colors/iceberg.vim https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim
    fi

    if [ ! -f "$HOME/.vim/plugin/autoclose.vim" ]; then
        # Installs autoclose plugin
        echo "Installing autoclose plugin to $HOME/.vim/plugin/autoclose.vim ..."
        curl -LSso $HOME/.vim/plugin/autoclose.vim https://www.vim.org/scripts/download_script.php?src_id=10873
    fi

    # If we are on a specific environment, we install additional plugins
    if [ "${TYPE}" == "work" ]; then
        echo "Detected using work setup. Additional plugins will also be installed, if not already: vim-terraform, vim-markdown-preview"
        confirm_user

        if [ ! -d "$HOME/.vim/bundle/vim-terraform" ]; then
            # Installs vim-terraform plugin
            echo "Installing vim-terraform plugin to $HOME/.vim/bundle/vim-terraform ..."
            mkdir -p $HOME/.vim/bundle/vim-terraform
            git clone git@github.com:hashivim/vim-terraform.git $HOME/.vim/bundle/vim-terraform
        fi
        
        if [ ! -d "$HOME/.vim/bundle/vim-markdown-preview" ]; then
            # Installs vim-markdown-preview plugin
            echo "Installing vim-markdown-preview plugin to $HOME/.vim/bundle/vim-markdown-preview ..."
            mkdir -p $HOME/.vim/bundle/vim-markdown-preview
            git clone git@github.com:JamshedVesuna/vim-markdown-preview.git $HOME/.vim/bundle/vim-markdown-preview
        fi
    fi

    echo "Installation of all plugins complete!"
    echo
}

# Installs additional packages that are leveraged from the terminal
terminal_install_pkgs() {
    echo "Now checking if there's additional terminal packages needed..."
    echo "The following plugins will be installed if not already installed: zsh-autosuggestions"
    confirm_user

    # Checks for zsh-autosuggestions plugin
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions into $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions..."
        mkdir -p $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        git clone git@github.com:zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
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

    echo "The following files will now be symlinked to this repo: $HOME/.gitconfig, $HOME/.tmux.conf, $HOME/.zshrc, $HOME/.zsh_exports, $HOME/.vimrc"
    confirm_user

    ln -sf ${dir_loc}/git/gitconfig $HOME/.gitconfig
    
    ln -sf ${dir_loc}/terminal/tmux.conf $HOME/.tmux.conf
    ln -sf ${dir_loc}/terminal/zshrc $HOME/.zshrc
    ln -sf ${dir_loc}/terminal/zsh_exports $HOME/.zsh_exports
    
    ln -sf ${dir_loc}/vim/vimrc $HOME/.vimrc

    echo "Finished symlinking configs!"
    echo
}

# Removes symlinks that are on the current system
delete_config_symlinks() {
    echo "The following symlinks will be removed: $HOME/.gitconfig, $HOME/.tmux.conf, $HOME/.zshrc, $HOME/.zsh_exports, $HOME/.vimrc"
    confirm_user

    # If file/symblink is already removed, we will skip that step
    echo "Removing symlinks/files mentioned..."
    if [ -f "$HOME/.gitconfig" ]; then
        rm $HOME/.gitconfig
    fi
    if [ -f "$HOME/.tmux.conf" ]; then
        rm $HOME/.tmux.conf
    fi
    if [ -f "$HOME/.zshrc" ]; then
        rm $HOME/.zshrc
    fi
    if [ -f "$HOME/.zsh_exports" ]; then
        rm $HOME/.zsh_exports
    fi
    if [ -f "$HOME/.vimrc" ]; then
        rm $HOME/.vimrc
    fi

    echo "Removed all symlinks and/or files!"
    echo
}

# Creates symlinks to a specific binary
# Presumes that the binary was already downloaded and verified
create_binary_symlinks() {
    echo "Checking that $HOME/CLI_Tools contains the specified binary..."
    if [ ! -f "$HOME/CLI_Tools/${SPEC_BIN_NAME}" ]; then
        echo "Error, cannot find ${SPEC_BIN_NAME} in $HOME/CLI_Tools, exiting..."
    else
        binaryNameClean=$(echo ${SPEC_BIN_NAME} | cut -d '_' -f 1)
        
        if [ ! -f "$HOME/CLI_Tools/bin_symlinks/${binaryNameClean}" ]; then
            echo "No existing symlink was found in $HOME/CLI_Tools. Will be creating symlink, ${binaryNameClean}, to ${SPEC_BIN_NAME}"
        else
            existingBinName=$(basename $(readlink ${HOME}/CLI_Tools/bin_symlinks/${binaryNameClean}))
            
            if [ "${existingBinName}" == "${SPEC_BIN_NAME}" ]; then
                echo "It appears that the symlink won't be changed, sine it is already using that binary."
                echo "Exiting script..."
                exit 0
            else
                echo "An existing symlink was found at $HOME/CLI_Tools/bin_symlinks!"
                echo "EXISTING: ${existingBinName}"
                echo "NEW: ${SPEC_BIN_NAME}"
                echo
                echo "This action will rewrite the current symlink to use the NEW binary."
            fi
        fi
        confirm_user

        ln -sf ${HOME}/CLI_Tools/${SPEC_BIN_NAME} $HOME/CLI_Tools/bin_symlinks/${binaryNameClean}
        echo "Successfully made ${SPEC_BIN_NAME} symlink in $HOME/CLI_Tools/bin_symlinks/${binaryNameClean}"
        echo "Please verify that PATH contains: $(pwd)/CLI_Tools/bin_symlinks so that the binary can be used."

        if [ "${existingBinName}" != "${SPEC_BIN_NAME}" ]; then
            delete_old_binary ${existingBinName}
        fi
    fi
}

# Deletes the specified binary symlink
delete_binary_symlink() {
    echo "Checking that $HOME/CLI_Tools contains the specified binary..."

    binaryNameClean=$(echo ${SPEC_BIN_NAME} | cut -d '_' -f 1)
    if [ ! -f "$HOME/CLI_Tools/${SPEC_BIN_NAME}" ]; then
        echo "Error, cannot find ${SPEC_BIN_NAME}, exiting..."
        exit 1
    elif [ ! -f "$HOME/CLI_Tools/bin_symlinks/${binaryNameClean}" ]; then
        echo "There is no symlink for ${binaryNameClean}! Exiting..."
        exit 1
    fi
    
    symlinkToDelete=$(readlink $HOME/CLI_Tools/bin_symlinks/${binaryNameClean})
    if [ $(basename ${symlinkToDelete}) == ${SPEC_BIN_NAME} ]; then
        echo "The following symlink will be removed: $HOME/CLI_Tools/bin_symlinks/${binaryNameClean}"
        echo "All new calls to ${binaryNameClean} will not work until this is set again!"
        confirm_user

        rm -f $HOME/CLI_Tools/bin_symlinks/${binaryNameClean}
        echo "Symlinked removed!"

        delete_old_binary ${SPEC_BIN_NAME}
    else
        echo "Current symlink with ${binaryNameClean} is not established with ${SPEC_BIN_NAME}, exiting..."
        exit 1
    fi
}

# Deletes the binary that was specified in this function's parameter
delete_old_binary() {
    binary_to_delete=$1

    if [ -f "$HOME/CLI_Tools/$binary_to_delete" ]; then
        echo
        echo "Would you like to remove the old binary, $binary_to_delete, as well?"
        echo "If not, the script will complete and the binary will still be in $HOME/CLI_Tools."
        confirm_user

        rm -f $HOME/CLI_Tools/$binary_to_delete
        echo "Removed old binary!"
    else
        echo "$HOME/CLI_Tools/$binary_to_delete is not found, exiting script..."
        exit 1
    fi
}

### Main
while getopts 'b:o:dh' option; do
    case "$option" in
        d)
            DELETE_MODE=true
            ;;
        o)
            TYPE=("$OPTARG")
            ;;
        b)
            SPEC_BIN_NAME=("$OPTARG")
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

# Main logic
if [ -n "${DELETE_MODE}" ]; then
    if [ -n "${SPEC_BIN_NAME}" ]; then
        # We are going to delete the specified binary symlink 
        echo "Preparing to manage binary symlinks..."
        delete_binary_symlink
    else
        # We are going to delete the all config symlinks from the system
        echo "Preparing to deleting current dotfiles on system..."
        delete_config_symlinks
    fi
elif [ -n "${SPEC_BIN_NAME}" ]; then
    # We are going to add a specific binary symlink 
    echo "Preparing to manage binary symlink..."
    create_binary_symlinks
elif [ -n "${TYPE}" ]; then
    # We are going to install all config symlinks onto the system
    # First, run prechecks and preconfigs
    echo "Preparing to install dotfiles on system..."
    pre_dot_checks
    vim_pre_config
    prep_binary_symlink_dirs

    # Then create symlinks and installs packages
    create_config_symlinks
    vim_install_plugins_themes
    terminal_install_pkgs

    echo "Installation complete! To reload the configuation, start a new terminal session."
    echo "To add binary symlinks, run this script with -b flag and specify a binary found in $HOME/CLI_Tools"
elif [[ -z "${TYPE}" ]] || [[ -z "${SPEC_BIN_NAME}" ]]; then
    usage
    exit 0
fi
