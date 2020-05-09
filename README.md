# My Dotfiles
Hey there! Welcome to my dotfile repository! Here you will find all of the configuration that I use in all of my projects, whether they are work related or personal usage, everything is in here.

## Table of Contents
1. [General Overview](#general-overview)
2. [How to Install](#how-to-install)
3. [How to Manage](#how-to-manage)

## General Overview
This repository contains the following configurations:
- `.gitignore`
- `.zshrc`
- `.bash_profile`
- `.vimrc`
- `.tmux`

Each of these configurations are organized in root folders, indicating which environment they are being used in. These environments are:
- `global`: Universal configs that can work for any situation
- `personal`: Configs that are used on my personal devices
- `work`: Configs that are used for my work devices

## How to Install
To make these dotfiles as modular as possible, all it takes to install these is running the script, `configure.sh` in the root directory.
```
cd /this/repo
./configure.sh -o <value>
```

If this amount of control is not necessary, these can alternatively be copied and pasted to the directory that the configs are needed:
```
cp /dir/to/this/repo/and/file /new/loc/for/file/
```

## How to Manage
Once the dot-files are installed, managing them is as simple as pulling any new update from the origin repository, which will reflect what is currently installed on the system.
```
cd /this/repo
git pull --rebase origin master
```

To delete the configuration from the system:
```
cd repo-dir
./configure.sh -d
```