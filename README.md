# maishiroma's Dotfiles
![Oh yah...](https://i1.wp.com/media1.tenor.com/images/a71c94c3aa7ad66a5051f81f48d14dd2/tenor.gif?w=688&ssl=1)

Hey there! Welcome to my dotfile repository! Here you will find all of the configuration that I use in all of my projects, whether they are work related or personal usage, everything is in here.

## Table of Contents
1. [General Overview](#general-overview)
2. [How to Install](#how-to-install)
3. [How to Manage](#how-to-manage)

## General Overview
This repository contains the following configurations:
- `.gitignore`
- `.gitconfig`
- `.zsh_exports`
- `.zshrc`
- `.bash_profile`
- `.vimrc`
- `.tmux.conf`

Each of these configurations are organized in root folders, indicating which environment they are being used in. These environments are:
- `global`: Universal configs that can work for any situation
- `personal`: Configs that are used on my personal devices
- `work`: Configs that are used for my work devices

## How to Install
Installation is as simple running `configure.sh` in the repo's root.
```
cd /this/repo
./configure.sh -o <value>
```

If this amount of control is not necessary, an alterntive solution is to manually copy and paste the specific config to wherever it is needed:
```
cp /dir/to/this/repo/and/file /new/loc/for/file/
```

## How to Manage
Once the dotfiles are installed, updating is as simple as pulling any new update from the repository, and starting a new terminal sesssion. 
```
cd /this/repo
git pull --rebase origin master
```

To remove the current/this configuration from the system:
```
cd /this/repo
./configure.sh -d
```

For more details on the script's flags:
```
./configure.sh -h
```
