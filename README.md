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
