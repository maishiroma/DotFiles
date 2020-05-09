#!/bin/bash
# The install script for my dot files! 
# Idea is to use symlinks to have it where my configs are pointed to this repository for easy managing.
# No need to install additional software, just run this and it should be done.

### Functions

# Prints out the help function of the script
usage () {
    cat << EOF
$(basename "$0") [-h] -- Configures a personal system using maishiroma's dot files.

This script aims to simplify the process of bringing onboard a new system. Currently, there are two available options that can be passed in the -o flag:
    
    personal (My personal configs)
    work     (What my work laptop has for configs)

FLAGS:
    -o:     Specifies which kind of dotfiles to leverage (REQUIRED)
    -d:     Enabled delete mode on this script
    -h:     Shows this help page

EXAMPLE:
    1.) ./configure.sh -o personal
        Configures a new installation of dot files using the personal configs

    2.) ./configure.sh -d
        Removes the current installation of dot files on the system
EOF
}

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
create_symlinks() {
    dir_loc=""
    if [ "${TYPE}" == "personal" ]; then
        echo "Symlinking configs from the personal directory"
        dir_loc="$(pwd)/personal"
    elif [ "${TYPE}" == "work" ]; then
        echo "Symlinking configs from the work directory"
        dir_loc="$(pwd)/work"
    else
        echo "That option is not valid here, sorry! Try asking for help. :)"
        exit 1
    fi

    echo "The following files will now be symlinked to this repo: ~/.gitconfig, ~/.tmux.conf, ~/.zshrc, ~/.zshrc_exports, ~/.vimrc"
    echo "Are you sure that you want to install?"
    echo "Please confirm with 'yes': "
    read userInput

    if [ "${userInput}" != "yes" ]; then
        echo "Leaving script safely."
        exit 0
    fi

    ln -sf ${dir_loc}/git/gitconfig ~/.gitconfig
    
    ln -sf ${dir_loc}/terminal/tmux.conf ~/.tmux.conf
    ln -sf ${dir_loc}/terminal/zshrc ~/.zshrc
    ln -sf ${dir_loc}/terminal/zshrc_exports ~/.zshrc_exports
    
    ln -sf ${dir_loc}/vim/vimrc ~/.vimrc

    echo "Finished symlinking configs."
    echo
}

# Removes symlinks that are on the current system
delete_symlinks() {
    echo "Are you sure that you want to remove all symlinks?"
    echo "All symlinks include: ~/.gitconfig, ~/.tmux.conf, ~/.zshrc, ~/.zshrc_exports, ~/.vimrc"
    echo "Please confirm with 'yes':"
    read userInput

    if [ "${userInput}" != "yes" ]; then
        echo "Leaving script safely."
        exit 0
    fi

    echo "Removing all symlinks mentioned..."
    rm ~/.gitconfig
    
    rm ~/.tmux.conf
    rm ~/.zshrc
    rm ~/.zshrc_exports
    
    rm ~/.vimrc

    echo "Removed symlinks."
    echo
}

# Outputs information about the post install
post_install() {
    echo "Installation complete!"
    echo "To complete installation, it is best to start a new terminal session to get all of the configs reloaded."
}

### Main
while getopts 'o:dh' option; do
    case "$option" in
        d)
            DELETE_MODE=true
            ;;
        o)
            TYPE=("$OPTARG")
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
    echo "Preparing to deleting current Dotfiles on system..."
    delete_symlinks
    echo "Deletion of dotfiles complete!"

elif [ -n "${TYPE}" ]; then
    # We are going to install the symlinks onto the system
    # First, run prechecks and preconfigs
    echo "Preparing to install Matt's Dotfiles on system..."
    pre_dot_checks
    vim_pre_config

    # Then create symlinks and installs packages
    create_symlinks
    vim_install_plugins_themes
    terminal_install_pkgs

    post_install

elif [ -z "${TYPE}" ]; then
    echo "The -o flag needs to be specified when doing an install. Please look at the -h for more help"
    exit 1
fi