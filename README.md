# Matthew's DotFiles
> The beginning of an era of configuration management

This repo will contain all of the configs that I will have for my personal setup. This is currently a work in progress and many things will change during this.

## Table of Contents
1) How to Install
2) How to Update

## How to Install
There are three types of scripts that simplify the installation of these files. Each of themhave varying degrees of how much they install.

#### Fully Automated Install
This installs everything that I use on a brand new computer. Like it is fresh out of the box. To do this, run the following commands in `Terminal`:
```
git clone https://github.com/shiro105/DotFiles.git
cd DotFiles/scripts
./bootstrap.sh
```
> NOTE: This automatically installs and utilizes, [rcm](https://github.com/thoughtbot/rcm) to your computer.

#### Semi Automated Install
This is for systems that do not want to use `rcm` for installing these files. To do this, run the following commands in `Terminal`:
```
git clone https://github.com/shiro105/DotFiles.git
cd DotFiles/scripts
./manual_bootstrap.sh
```

#### Vim Install
This only installs all of the plugins I use for Vim. Does not touch anything else in the system. To install this, run the following commands in `Terminal`:
```
git clone https://github.com/shiro105/DotFiles.git
cd DotFiles/scripts
./vim_bootstrap.sh
```
#### Windows 10 Install
Due to the nature of Windows, the installation of my things is a bit different. In this case, there is no script, but rather, we will be using the help of __Git Bash__ to get something close to what we have on Mac.

1) Make sure you get [Git Bash](https://git-scm.com/downloads) installed.
2) Do the following:
  - Make a copy of the `bash_profile_git` and move it to `$HOME/.bash_profile`
  - Make a copy of the `vimrc_windows` and move it to `$HOME/.vimrc`
3) Create a folder called `vimfiles` in the `$HOME` directory and make sure to add in the following folders in it:
  - `autoload`
  - `plugin`
  - `colors`
> NOTE: The `vimfiles` is basically the _same_ thing as the `.vim` folder in Mac.
4) Download the following items into these folders:
  - [Pathogen](https://github.com/tpope/vim-pathogen) and in `autoload`
  - [autoclose](https://www.vim.org/scripts/script.php?script_id=1849) and in `plugin`
  - [iceberg theme](https://github.com/cocopon/iceberg.vim) and in `colors`
> NOTE: If there are any other plugins, refer to the [scripts README](scripts/README.md) for specific ones
4) Go into Git Bash and run the following command: `cd && source .bash_profile`

## How to Update
Depending on how you installed these files, there's various ways on how you'd update these files whenever this repository changes.

#### Fully Automated Install
1) Run the following command in the root directory of this repository:
```
git pull origin master
cd Dotfiles
rcup
```

#### Semi Automated Install
1) Run the following command:
```
git pull origin master
cd DotFiles/scripts
./manual_bootstrap.sh
```

#### Vim Install
1) Run the following command:
```
git pull origin master
cd DotFiles/scripts
./vim_bootstrap.sh
```

#### Windows 10 Install
Unfortunatly, the only way to update what we have on our machine is to simply copy and paste the `bash_profile_git` and `vimrc_windows` into their respective spots.
