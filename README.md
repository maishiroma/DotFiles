# Matthew's DotFiles
> The beginning of an era of configuration management

This repo will contain all of the configs that I will have for my personal setup. This is currently a work in progress and many things will change during this.

## Table of Contents
1) How to Install
2) Post Install
3) How to Update

## How to Install
1) Clone this repo down:
```
git clone https://github.com/shiro105/DotFiles.git
```
2) Go into the scripts folder and run the bootstrap script specific to your environment.
```
cd DotFiles/scripts
./<nameOfBootstrapScript>
```
> NOTE: If you don't want to use a dot file manager, run the `manual_bootstrap.sh` script instead. This only installs the bare minimum on your system.

## Post-Install
(This is optional, but if you do not do this, you WILL need to remove all of the lines below `Vim Plugins` in the `.vimrc` file)
1) Navigate to the [README](https://github.com/shiro105/DotFiles/tree/master/scripts/README.md) in the `scripts` directory and follow the instructions on there.

## How to Update
1) Simply run `rcup` once you have ran through the initial installment. 

> NOTE: If you used `manual_bootstrap.sh` to install all of the dotfiles, simply pull all new changes from this repo and rerun that script again.
